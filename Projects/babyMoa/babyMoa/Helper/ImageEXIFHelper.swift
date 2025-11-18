//
//  ImageEXIFHelper.swift
//  babyMoa
//
//  Created by pherd on 11/18/25.
//

import CoreLocation
import Foundation
import ImageIO

/// 이미지 EXIF 메타데이터에서 GPS 정보 추출 Helper
///
/// **왜 필요한가?**
/// - iOS 14+ PhotosPicker는 itemIdentifier를 제공하지 않는 경우가 많음
/// - "모든 사진" 권한이 있어도 itemIdentifier가 nil일 수 있음 (iCloud 동기화, Live Photos 등)
/// - EXIF에서 직접 읽으면 100% 안정적 (GPS 정보가 있다면)
///
/// **동작 방식:**
/// 1. 이미지 Data → CGImageSource 생성
/// 2. EXIF 메타데이터 딕셔너리 추출
/// 3. GPS 딕셔너리에서 위도/경도 파싱
/// 4. 남위/서경 처리 (S/W 방향 체크)
struct ImageEXIFHelper {

    /// 이미지 Data에서 EXIF GPS 정보 추출
    static func extractLocation(from imageData: Data) -> CLLocation? {
        // 1. CGImageSource 생성
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil)
        else {
            print("⚠️ [EXIF] CGImageSource 생성 실패")
            return nil
        }

        // 2. 메타데이터 추출
        guard
            let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
                as? [String: Any]
        else {
            print("⚠️ [EXIF] 메타데이터 추출 실패")
            return nil
        }

        // 3. GPS 딕셔너리 추출
        guard
            let gpsData = metadata[kCGImagePropertyGPSDictionary as String]
                as? [String: Any]
        else {
            print("⚠️ [EXIF] GPS 메타데이터 없음 (사진에 위치 정보가 없음)")
            return nil
        }

        // 4. 위도/경도 파싱
        guard
            let latitude = gpsData[kCGImagePropertyGPSLatitude as String]
                as? Double,
            let longitude = gpsData[kCGImagePropertyGPSLongitude as String]
                as? Double,
            let latitudeRef = gpsData[kCGImagePropertyGPSLatitudeRef as String]
                as? String,
            let longitudeRef = gpsData[
                kCGImagePropertyGPSLongitudeRef as String
            ] as? String
        else {
            print("⚠️ [EXIF] GPS 좌표 파싱 실패")
            return nil
        }

        // 5. 남위/서경 처리
        // - N(북위): 그대로, S(남위): 음수
        // - E(동경): 그대로, W(서경): 음수
        let finalLatitude = (latitudeRef == "S") ? -latitude : latitude
        let finalLongitude = (longitudeRef == "W") ? -longitude : longitude

        print("✅ [EXIF] 위치 추출 성공: \(finalLatitude), \(finalLongitude)")

        return CLLocation(latitude: finalLatitude, longitude: finalLongitude)
    }
}
