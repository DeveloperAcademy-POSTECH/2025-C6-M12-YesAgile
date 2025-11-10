//
//  Journey.swift
//  babyMoa
//
//  Created by pherd on 11/7/25.
//
import SwiftUI
import CoreLocation

/// 여정 도메인 모델
/// 서버 ResponseModel과 달리 UI에 최적화된 형태로 데이터 보관
struct Journey: Entity, Hashable {
    var journeyId : Int
    var journeyImage: UIImage?
    var latitude: Double
    var longitude: Double
    var date: Date  // ⚠️ String이 아닌 Date: Calendar API 사용을 위함 나중에 변환 요함
    var memo: String
    
    // MARK: - Computed Properties
    
    /// CLLocationCoordinate2D로 변환 (MapKit 사용)
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// UI 표시용 짧은 날짜 형식 (예: "2025.11.07")
    /// Date+Extensions의 computed property 활용
    var formattedDate: String {
        date.yyyyMMdd  // DateFormatter 재사용으로 성능 최적화
    }
    
    /// UI 표시용 한글 날짜 형식 (예: "2025년 11월 07일")
    /// Date+Extensions의 computed property 활용
    var formattedDateKorean: String {
        date.yyyyMMddKorean
    }
    
    // MARK: - Hashable
    
    /// ForEach(journies, id: \.self) 사용을 위한 Hashable 구현
    static func == (lhs: Journey, rhs: Journey) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude &&
        lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
        hasher.combine(date)
    }
}

// MARK: - Mock Data

#if DEBUG
extension Journey {
    static var mockData: [Journey] {
        [
            Journey(
                journeyId: 1,
                journeyImage: createSampleImage(systemName: "star.fill", color: .systemYellow),
                latitude: 37.5665,
                longitude: 126.9780,
                date: Date(),
                memo: "서울 나들이"
            ),
            Journey(
                journeyId: 1,
                journeyImage: createSampleImage(systemName: "heart.fill", color: .systemPink),
                latitude: 37.5642,
                longitude: 126.9770,
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                memo: "공원 산책"
            ),
            Journey(
                journeyId: 1,
                journeyImage: createSampleImage(systemName: "leaf.fill", color: .systemGreen),
                latitude: 37.5700,
                longitude: 126.9800,
                date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                memo: "한강 피크닉"
            )
        ]
    }
    
    private static func createSampleImage(systemName: String, color: UIColor) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular)
        return UIImage(systemName: systemName, withConfiguration: config)?
            .withTintColor(color, renderingMode: .alwaysOriginal) ?? UIImage()
    }
}
#endif
