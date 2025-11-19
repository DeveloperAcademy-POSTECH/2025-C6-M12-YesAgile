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
    var journeyImage: UIImage  // ✅ 사진 필수 (non-optional)
    var latitude: Double
    var longitude: Double
    var date: Date  // ⚠️ String이 아닌 Date: Calendar API 사용을 위함 나중에 변환 요함
    var memo: String

    // MARK: - Computed Properties

    /// CLLocationCoordinate2D로 변환 (MapKit 사용)
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// 지도에 표시 가능한 유효한 위치인지 확인
    /// - (0, 0) 제외 (위치 정보 없음)
    /// - GPS 유효 범위 내 (위도: -90~90, 경도: -180~180)
    var hasValidLocation: Bool {
        latitude != 0 && longitude != 0 &&
        latitude >= -90 && latitude <= 90 &&
        longitude >= -180 && longitude <= 180
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

    // MARK: - Hashable 이거 공부하기 ㅜㅜ

    /// ForEach(journies, id: \.self) 사용을 위한 Hashable 구현 journeyId + 날짜 동일 여정
    static func == (lhs: Journey, rhs: Journey) -> Bool {
        lhs.journeyId == rhs.journeyId && lhs.date == rhs.date
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(journeyId)
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
                    journeyImage: UIImage(systemName: "star.fill")!,  // ✅ force unwrap (system image는 항상 존재)
                    latitude: 37.5665,
                    longitude: 126.9780,
                    date: Date(),
                    memo: "서울 나들이"
                ),
                Journey(
                    journeyId: 5,
                    journeyImage: UIImage(systemName: "star.fill")!,  // ✅ force unwrap (system image는 항상 존재)
                    latitude: 37.5665,
                    longitude: 126.9790,
                    date: Date(),
                    memo: "서울 나들이2"
                ),
                Journey(
                    journeyId: 2,
                    journeyImage: UIImage(systemName: "heart.fill")!,
                    latitude: 37.5642,
                    longitude: 126.9770,
                    date: Calendar.current.date(
                        byAdding: .day,
                        value: -1,
                        to: Date()
                    ) ?? Date(),
                    memo: "공원 산책"
                ),
                Journey(
                    journeyId: 3,
                    journeyImage: UIImage(systemName: "leaf.fill")!,
                    latitude: 37.5700,
                    longitude: 126.9800,
                    date: Calendar.current.date(
                        byAdding: .day,
                        value: -3,
                        to: Date()
                    ) ?? Date(),
                    memo: "한강 피크닉"
                ),
                Journey(
                    journeyId: 4,
                    journeyImage: UIImage(systemName: "camera.fill")!,
                    latitude: 37.5700,
                    longitude: 126.0000,
                    date: Calendar.current.date(
                        byAdding: .day,
                        value: -5,
                        to: Date()
                    ) ?? Date(),
                    memo: "한강 피크닉2"
                ),

            ]
        }
    }
#endif

//지도에다가 핀 꼽아두듯, 위도경도 추출 (사진)
