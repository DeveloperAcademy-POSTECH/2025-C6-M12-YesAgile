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
    // Optimistic UI를 위해 서버 ID(journeyId) 대신 UUID를 고유 식별자로 사용 가능하도록 확장
    var id: UUID = UUID() // 로컬에서 고유하게 식별하기 위한 ID
    var journeyId: Int
    
    // UI 표시용 이미지 (nil일 경우 imageUrl에서 로드)
    // 업로드 직후에는 이 프로퍼티에 로컬 이미지를 담아서 즉시 표시
    var journeyImage: UIImage?
    // 리포지토리 패턴 지원을 위한 원본 URL
    var imageUrl: String?
    var latitude: Double
    var longitude: Double
    var date: Date
    var memo: String
    
    // Optimistic UI: 임시 데이터 여부 (업로드 중인지 확인)
    var isTemporary: Bool = false
    
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
    
    /// UI 표시용 한글 날짜 형식 (예: "2025년 11월 07일")
    var formattedDateKorean: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    // MARK: - Hashable
    // Optimistic UI 지원을 위해 UUID와 journeyId를 모두 고려
    static func == (lhs: Journey, rhs: Journey) -> Bool {
        // 같은 UUID면 같은 객체 (임시 객체 포함)
        if lhs.id == rhs.id { return true }
        // 둘 다 서버 ID가 있고 같으면 같은 객체
        if lhs.journeyId == rhs.journeyId && lhs.journeyId != 0 { return true }
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(journeyId)
    }
}

// MARK: - Mock Data
#if DEBUG
extension Journey {
    static var mockData: [Journey] {
        [
            Journey(
                journeyId: 1,
                journeyImage: UIImage(systemName: "star.fill"),
                imageUrl: nil,
                latitude: 37.5665,
                longitude: 126.9780,
                date: Date(),
                memo: "서울 나들이"
            ),
            Journey(
                journeyId: 2,
                journeyImage: UIImage(systemName: "heart.fill"),
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
