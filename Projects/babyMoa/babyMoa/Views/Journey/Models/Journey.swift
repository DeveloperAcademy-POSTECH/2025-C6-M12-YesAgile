//
//  Journey.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//

import CoreLocation
import Foundation
import PhotosUI
/// 여정 도메인 모델
struct Journey: Identifiable, Hashable {
    // MARK: - Properties

    let id: String
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D
    var date: Date
    var memo: String

    // MARK: - Initialization

    init(
        id: String = UUID().uuidString,
        image: UIImage? = nil,
        coordinate: CLLocationCoordinate2D,
        date: Date,
        memo: String
    ) {
        self.id = id
        self.image = image
        self.coordinate = coordinate
        self.date = date
        self.memo = memo
    }

    // MARK: - Computed Properties

    /// 위도
    var latitude: Double {
        coordinate.latitude
    }

    /// 경도
    var longitude: Double {
        coordinate.longitude
    }

    // MARK: - Hashable

    static func == (lhs: Journey, rhs: Journey) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Formatting Extensions
// 바바가 해놓으신 Extension 활용하기

extension Journey {
    /// 날짜 표시 (예: "2025년 11월 5일")
    var formattedDate: String {
        date.yyyyMMddKorean
    }

    /// 짧은 날짜 표시 (예: "2025.11.05")
    var shortFormattedDate: String {
        date.yyyyMMdd
    }
}
