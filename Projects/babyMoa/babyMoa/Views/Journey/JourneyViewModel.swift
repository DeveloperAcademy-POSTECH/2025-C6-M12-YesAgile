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
final class JourneyViewModel {
    var coordinator: BabyMoaCoordinator
    
    // MARK: - Properties
    
    var journies: [Journey] = []  // ✅ journeys → journies (레퍼런스 네이밍)
    
    // MARK: - Initialization
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Business Logic
    
    /// 서버에서 월별 여정 데이터 가져오기
    func fetchJournies(year: Int, month: Int) async {
        // TODO: BabyMoaService 연동
//        guard let babyId = SelectedBaby.babyId else { return }
//        let result = await BabyMoaService.shared.getGetJourniesAtMonth(babyId: babyId, year: year, month: month)
//        switch result {
//        case .success(let success):
//            guard let journeyResModels = success.data else { return }
//            for journeyResModel in journeyResModels {
//                let journey = await journeyResModel.toDomain()
//                journies.append(journey)
//            }
//        case .failure(let error):
//            print(error)
//        }
        // TODO: 테스트 (Ted 맘대로 한거)
        journies = Journey.mockData
    }
    
    /// 날짜별로 여정을 그룹화
    func journiesGroupedByDate() -> [Date: [Journey]] {
        Dictionary(grouping: journies) { journey in
            Calendar.current.startOfDay(for: journey.date)
        }
    }
    
    /// 특정 날짜의 여정 가져오기
    func journies(for date: Date) -> [Journey] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return journies.filter { journey in
            Calendar.current.startOfDay(for: journey.date) == startOfDay
        }
    }
    
    /// 여정 추가
    func addJourney(_ journey: Journey) async {
        // TODO: 서버 POST /journey
        journies.append(journey)
    }
    
    /// 여정 삭제
    /// - Parameter journey: 삭제할 여정
    func removeJourney(_ journey: Journey) async {
        // ✅ Equatable 사용 (id 대신)
        journies.removeAll { $0 == journey }
    }
    
    /// 여정 업데이트
    /// - Parameter journey: 업데이트할 여정
    func updateJourney(_ journey: Journey) async {
        // ✅ firstIndex(of:) 사용 (Equatable이므로 가능)
        if let index = journies.firstIndex(of: journey) {
            journies[index] = journey
        }
    }
}
