//
//  GetJourniesAtMonthResModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
// GET / array<object>
// ResponseModelable 사용예정 - 퍼드
import UIKit
import Foundation

struct GetJourniesAtMonthResModel: ResponseModelable {
    var journeyId: Int // 추가한 사항
    var journeyImageUrl: String
    var latitude: Double
    var longitude: Double
    var date: String // "2025-11-01"
    var memo: String
    // MARK: - ResponseModel → Domain 변환
    
    func toDomain() async -> Journey {
        // MARK: - 이미지 다운로드 및 리사이즈
        
        /// 서버에서 이미지 다운로드
        /// - 성공: 리사이즈 후 사용 (1024x1024로 제한)
        /// - 실패: 기본 placeholder 이미지 사용 (네트워크 에러, URL 문제 등)
        /// - Note: Journey.journeyImage가 UIImage (non-optional)로 변경되어 Fallback 필수
        let downloadedImage = await ImageManager.shared.downloadImage(from: journeyImageUrl)
        let image = downloadedImage ?? UIImage(systemName: "photo")!
        
        // ✅ 배터리/메모리 최적화: 다운로드 받은 이미지도 리사이즈
        let resizedImage = ImageManager.shared.resizeImage(image, maxSize: 1024)
        
        return Journey(
            journeyId: journeyId,
            journeyImage: resizedImage,  // ✅ 리사이즈된 이미지 사용
            latitude: latitude,
            longitude: longitude,
            date: DateFormatter.yyyyDashMMDashdd.date(from: date)!,
            memo: memo
        )
    }
}


