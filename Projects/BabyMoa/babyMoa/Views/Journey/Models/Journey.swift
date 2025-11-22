//
//  Journey.swift
//  babyMoa
//
//  Created by pherd on 11/7/25.
//

import CoreLocation
import UIKit

/// 여정 도메인 모델
/// 서버 ResponseModel과 달리 UI에 최적화된 형태로 데이터 보관
struct Journey: Entity, Hashable, Identifiable {
    // MapKit ForEach에서 사용하기 위한 Identifiable 구현
    var id: Int { journeyId }
    var journeyId: Int
    // UI 표시용 이미지 (ViewModel에서 다운로드 후 설정)
    var journeyImage: UIImage
    // 리포지토리 패턴 지원을 위한 원본 URL
    var imageUrl: String?
    var latitude: Double
    var longitude: Double
    var date: Date
    var memo: String
    
    // 리포지토리 패턴 및 캐싱 지원 
    var cachedImage: UIImage? {
        return journeyImage
    }
    
    // MARK: - Computed Properties
    
    /// CLLocationCoordinate2D로 변환 (MapKit 사용)
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// 지도에 표시 가능한 유효한 위치인지 확인
    var hasValidLocation: Bool {
        latitude != 0 && longitude != 0 && latitude >= -90 && latitude <= 90
            && longitude >= -180 && longitude <= 180
    }
    
    /// UI 표시용 짧은 날짜 형식 (예: "2025.11.07")
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    /// UI 표시용 한글 날짜 형식 (예: "2025년 11월 07일")
    var formattedDateKorean: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    // MARK: - Hashable
    static func == (lhs: Journey, rhs: Journey) -> Bool {
        lhs.journeyId == rhs.journeyId &&
        lhs.date == rhs.date &&
        lhs.memo == rhs.memo &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude &&
        lhs.journeyImage === rhs.journeyImage
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(journeyId)
        hasher.combine(date)
        hasher.combine(memo)
    }
}

// MARK: - Mock Data
#if DEBUG
extension Journey {
    static var mockData: [Journey] {
        [
            Journey(
                journeyId: 1,
                journeyImage: UIImage(systemName: "star.fill")!,
                imageUrl: nil,
                latitude: 37.5665,
                longitude: 126.9780,
                date: Date(),
                memo: "서울 나들이"
            ),
            Journey(
                journeyId: 2,
                journeyImage: UIImage(systemName: "heart.fill")!,
                imageUrl: nil,
                latitude: 37.5642,
                longitude: 126.9770,
                date: Date().addingTimeInterval(-86400),
                memo: "공원 산책"
            )
        ]
    }
}
#endif
