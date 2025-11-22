//
//  JourneyModel.swift
//  babyMoa
//
//  Created by pherd on 11/7/25.
//

import Foundation
import SwiftUI

// 여정 도메인 모델 (Pure Data Model)
struct Journey: Entity, Identifiable {
    var id: Int { journeyId }
    var journeyId: Int
    var imageURL: String
    var latitude: Double
    var longitude: Double
    var date: Date
    var memo: String
}

// MARK: - Mock Data
extension Journey {
    static var mockData: [Journey] {
        [
            Journey(
                journeyId: 1,
                imageURL: "https://images.unsplash.com/photo-1722074740141-e55c3fc6e1b6?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                latitude: 37.5665,
                longitude: 126.9780,
                date: Date(),
                memo: "서울 나들이"
            ),
            Journey(
                journeyId: 5,
                imageURL: "https://images.unsplash.com/photo-1722074740141-e55c3fc6e1b6?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                latitude: 37.5665,
                longitude: 126.9790,
                date: Date(),
                memo: "서울 나들이2"
            ),
            Journey(
                journeyId: 2,
                imageURL: "https://images.unsplash.com/photo-1722074740141-e55c3fc6e1b6?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                latitude: 37.5642,
                longitude: 126.9770,
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                memo: "공원 산책"
            ),
            Journey(
                journeyId: 3,
                imageURL: "https://images.unsplash.com/photo-1722074740141-e55c3fc6e1b6?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                latitude: 37.5700,
                longitude: 126.9800,
                date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                memo: "한강 피크닉"
            ),
            Journey(
                journeyId: 4,
                imageURL: "https://images.unsplash.com/photo-1722074740141-e55c3fc6e1b6?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                latitude: 37.5700,
                longitude: 126.0000,
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                memo: "한강 피크닉2"
            ),
        ]
    }
}
