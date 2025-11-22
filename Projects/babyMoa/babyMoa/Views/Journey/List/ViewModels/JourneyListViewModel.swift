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

    // 부모 ViewModel 참조 (데이터 동기화 및 API 호출 위임)
    private var parentVM: JourneyViewModel

    init(date: Date, journies: [Journey], parentVM: JourneyViewModel) {
        self.date = date
        self.journies = journies
        self.parentVM = parentVM
    }

    /// 여정 목록 갱신 (부모 데이터 기반)
    func refresh() {
        // 부모 VM의 최신 데이터에서 해당 날짜 여정만 다시 필터링하여 업데이트
        self.journies = parentVM.journies.filter {
            $0.date.isSameDay(as: self.date)
        }
    }

    /// 여정 삭제
    func deleteJourney(_ journey: Journey) async -> Bool {
        let success = await parentVM.removeJourney(journey)
        if success {
            refresh()
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
        let success = await parentVM.updateJourney(
            journey: journey,
            image: image,
            memo: memo,
            latitude: latitude,
            longitude: longitude
        )

        if success {
            refresh()  // 데이터 갱신 -> UI 자동 업데이트 (시트 안 닫힘)
        }

        return success
    }
}
