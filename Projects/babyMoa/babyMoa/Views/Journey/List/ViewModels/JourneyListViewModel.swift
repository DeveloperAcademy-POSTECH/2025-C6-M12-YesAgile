//
//  JourneyListViewModel.swift
//  babyMoa
//
//  Created by pherd on 11/20/25.
//  Refactored on 11/22/25
//

import Foundation
import SwiftUI

@MainActor
@Observable class JourneyListViewModel {
    let date: Date
    var journeys: [Journey]

    // 액션 핸들러 (외부 주입)
    var onDelete: ((Journey) async -> Bool)?
    var onUpdate: ((Journey, UIImage, String, Double, Double) async -> Bool)?

    init(
        date: Date,
        journeys: [Journey],
        onDelete: ((Journey) async -> Bool)? = nil,
        onUpdate: ((Journey, UIImage, String, Double, Double) async -> Bool)? = nil
    ) {
        self.date = date
        self.journeys = journeys
        self.onDelete = onDelete
        self.onUpdate = onUpdate
    }

    /// 여정 삭제
    func deleteJourney(_ journey: Journey) async -> Bool {
        guard let deleteAction = onDelete else { return false }
        let success = await deleteAction(journey)
        if success {
            // 로컬 리스트에서 제거
            if let index = journeys.firstIndex(of: journey) {
                journeys.remove(at: index)
            }
        }
        return success
    }

    /// 여정 수정
    func updateJourney(
        journey: Journey,
        image: UIImage,
        memo: String,
        latitude: Double,
        longitude: Double
    ) async -> Bool {
        guard let updateAction = onUpdate else { return false }
        
        let success = await updateAction(journey, image, memo, latitude, longitude)

        if success {
            // 수정된 내용 반영 (서버 갔다온 데이터로 교체하는 게 좋지만, 여기서는 UI 갱신을 위해 로컬 수정)
            if let index = journeys.firstIndex(of: journey) {
                // 이미지는 그대로, 내용은 수정된 값으로 임시 반영 (실제론 MainVM이 fetch해서 덮어씌움)
                var updated = journey
                updated.journeyImage = image
                updated.memo = memo
                journeys[index] = updated
            }
        }

        return success
    }
}
