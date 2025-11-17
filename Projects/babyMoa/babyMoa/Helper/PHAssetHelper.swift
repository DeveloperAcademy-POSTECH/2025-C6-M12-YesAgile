//
//  PHAssetHelper.swift
//  BabyMoa
//
//  Created by pherd on 11/17/25.
//
//  PHPickerViewController/PhotosPicker로 선택한 사진의 메타데이터 추출
//  - 촬영 날짜 (creationDate)
//  - 위치 정보 (location - 위도/경도)

import Photos
import CoreLocation

// MARK: - PHAssetHelper

/// PhotosPicker로 선택한 사진의 메타데이터(날짜, 위치)를 추출하는 유틸리티
///
/// **역할**:
/// - PhotosPickerItem의 itemIdentifier를 사용하여 PHAsset 접근
/// - PHAsset에서 촬영 날짜(creationDate) 추출
/// - PHAsset에서 위치 정보(CLLocation) 추출
///
/// **사용 방법**:
/// ```swift
/// if let metadata = await PHAssetHelper.extractMetadata(from: itemIdentifier) {
///     let date = metadata.date  // 촬영 날짜
///     let location = metadata.location  // 위치 정보
///     print("위도: \(location?.coordinate.latitude ?? 0)")
///     print("경도: \(location?.coordinate.longitude ?? 0)")
/// }
/// ```
///
/// **주의사항**:
/// To-Do: 사진 라이브러리 접근 권한 필요 (Info.plist에 NSPhotoLibraryUsageDescription 추가 해야함)
/// - 위치 정보가 없는 사진의 경우 location은 nil
/// - 스크린샷 등 촬영 날짜가 없는 경우 date는 nil
///
/// **레퍼런스**:
/// - BabyMoaMap2 프로젝트의 PHAssetHelper 참고
/// - 현재 프로젝트 스타일에 맞게 주석 및 에러 처리 개선
struct PHAssetHelper {
    
    /// PhotosPickerItem의 itemIdentifier로 PHAsset 메타데이터 추출
    ///
    /// **동작 방식**:
    /// 1. itemIdentifier (PhotosPickerItem의 고유 ID) 검증
    /// 2. PHAsset.fetchAssets로 해당 itemIdentifier의 PHAsset 가져오기
    /// 3. PHAsset에서 creationDate, location 추출
    /// 4. 결과 로깅 (디버깅용)
    ///
    /// **PhotosPickerItem.itemIdentifier**:
    /// - PhotosPickerItem 선택 시 자동으로 제공되는 고유 ID
    /// - PHAsset의 localIdentifier와 매핑됨
    /// - 이를 통해 PHAsset에 접근하여 메타데이터 추출 가능
    ///
    /// **반환값**:
    /// - date: 촬영 날짜 (스크린샷 등은 nil 가능)
    /// - location: 위치 정보 (위치 태그가 없으면 nil)
    ///
    /// **에러 케이스**:
    /// - itemIdentifier가 nil → nil 반환
    /// - PHAsset을 찾을 수 없음 → nil 반환
    /// - 메타데이터가 없음 → (date: nil, location: nil) 반환
    ///
    /// - Parameter itemIdentifier: PhotosPickerItem.itemIdentifier
    /// - Returns: (촬영 날짜, 위치) 튜플 또는 nil
    static func extractMetadata(from itemIdentifier: String?) async -> (date: Date?, location: CLLocation?)? {
        // 1. itemIdentifier 검증
        guard let itemIdentifier = itemIdentifier else {
            print("⚠️ [PHAssetHelper] itemIdentifier가 없습니다")
            return nil
        }
        
        // 2. PHAsset 가져오기
        // - fetchAssets(withLocalIdentifiers:)를 사용하여 itemIdentifier로 PHAsset 조회
        // - PhotosPickerItem.itemIdentifier는 PHAsset.localIdentifier와 동일
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [itemIdentifier], options: nil)
        guard let asset = fetchResult.firstObject else {
            print("⚠️ [PHAssetHelper] PHAsset을 찾을 수 없습니다 (itemIdentifier: \(itemIdentifier))")
            return nil
        }
        
        // 3. 메타데이터 추출
        let creationDate = asset.creationDate  // 촬영 날짜 (Date?)
        let location = asset.location  // 위치 정보 (CLLocation?)
        
        // 4. 결과 로깅 (디버깅용)
        if let date = creationDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone.current
            let formattedDate = formatter.string(from: date)
            print("✅ [PHAssetHelper] 촬영 날짜: \(formattedDate)")
        } else {
            print("⚠️ [PHAssetHelper] 촬영 날짜 없음 (스크린샷 또는 다운로드 이미지)")
        }
        
        if let loc = location {
            print("✅ [PHAssetHelper] 위치 정보: 위도 \(loc.coordinate.latitude), 경도 \(loc.coordinate.longitude)")
        } else {
            print("⚠️ [PHAssetHelper] 위치 정보 없음 (위치 태그 비활성화 또는 실내 촬영)")
        }
        
        return (creationDate, location)
    }
}

