//
//  JourneyViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//

import CoreLocation
import Foundation
import SwiftUI

/// Journey 비즈니스 로직을 관리하는 ViewModel
@Observable
class JourneyViewModel {
    // MARK: - Properties
    
    var journeys: [Journey] = []
    
    // MARK: - Initialization
    
    init(journeys: [Journey] = []) {
        self.journeys = journeys
    }
    
    // MARK: - Business Logic
    
    /// 날짜별로 여정을 그룹화
    func journeysGroupedByDate() -> [Date: [Journey]] {
        Dictionary(grouping: journeys) { journey in
            Calendar.current.startOfDay(for: journey.date)
        }
    }
    
    /// 특정 날짜의 여정 가져오기
    func journeys(for date: Date) -> [Journey] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return journeys.filter { journey in
            Calendar.current.startOfDay(for: journey.date) == startOfDay
        }
    }
    
    /// 여정 추가
    func addJourney(_ journey: Journey) {
        journeys.append(journey)
    }
    
    /// 여정 삭제 백엔드 딜리트 연동 물어보기. 
    func removeJourney(_ journey: Journey) {
        journeys.removeAll { $0.id == journey.id }
    }
    
    /// 여정 업데이트
    func updateJourney(_ journey: Journey) {
        if let index = journeys.firstIndex(where: { $0.id == journey.id }) {
            journeys[index] = journey
        }
    }
}
