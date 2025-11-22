//
//  JourneyListViewModel.swift
//  babyMoa
//
//  Created by pherd on 11/20/25.
//

import Foundation
import SwiftUI

@MainActor
@Observable class JourneyListViewModel {
    let date: Date
    var journies: [Journey]

    private let onDelete: (Journey) async -> Bool
    private let onUpdate: (Journey, UIImage, String, Double, Double) async -> Bool

    init(
        date: Date,
        journies: [Journey],
        onDelete: @escaping (Journey) async -> Bool,
        onUpdate: @escaping (Journey, UIImage, String, Double, Double) async -> Bool
    ) {
        self.date = date
        self.journies = journies
        self.onDelete = onDelete
        self.onUpdate = onUpdate
    }

    func deleteJourney(_ journey: Journey) async -> Bool {
        let success = await onDelete(journey)
        if success {
            journies.removeAll { $0.id == journey.id }
        }
        return success
    }

    func updateJourney(
        journey: Journey,
        image: UIImage,
        memo: String,
        latitude: Double,
        longitude: Double
    ) async -> Bool {
        let success = await onUpdate(journey, image, memo, latitude, longitude)
        if success {
            if let index = journies.firstIndex(where: { $0.id == journey.id }) {
                // This local update is tricky because the new image is not available here.
                // The parent should handle the full refresh. For now, just update what we can.
                journies[index].memo = memo
                journies[index].latitude = latitude
                journies[index].longitude = longitude
            }
        }
        return success
    }
}
