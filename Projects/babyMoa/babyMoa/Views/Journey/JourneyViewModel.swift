//
//  JourneyViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//
import Foundation
import SwiftUI

/// Journey 비즈니스 로직을 관리하는 ViewModel
/// - Note: 순수 데이터 관리만 담당 (네비게이션 책임 없음)
//         - fetchJournies: 데이터 조회만
//         - addJourney: 데이터 추가만
//         - removeJourney: 데이터 삭제만
//         → 화면 전환은 View(JourneyView)에서 담당
@MainActor
@Observable class JourneyViewModel {
    /// 여정 데이터 배열
    var journies: [Journey] = []

    /// 여정 추가
    /// - 실제 모드: API POST 후 다시 조회
    func addJourney(_ journey: Journey) async {
        // TODO: 나중에 API로 교체
        // let reqModel = AddJourneyReqModel(...)
        // let result = await BabyMoaService.shared.postAddJourney(reqModel)
        // if result.isSuccess {
        //     await fetchJournies(babyId: babyId, year: 2025, month: 11)
        // }

        // Mock 모드: 배열에 추가
        journies.append(journey)
        
    }

    /// 여정 삭제
    /// - Parameter journey: 삭제할 여정
    func removeJourney(_ journey: Journey) async {
        // ✅ Equatable 사용 (id 대신)
        journies.removeAll { $0 == journey }
    }
    
    // MARK: - Fetch 함수
    /// 특정 날짜의 월 데이터 조회
    /// - Parameter date: 조회할 월이 포함된 날짜
    func fetchJournies(for date: Date) async {
        // 1. babyId 확인
        guard let babyId = SelectedBaby.babyId else {
            print("⚠️ babyId 없음 - MainTabViewModel에서 설정 필요")
            
            #if DEBUG
            print("📦 개발 환경: Mock 데이터 \(Journey.mockData.count)개 로드")
            journies = Journey.mockData
            #else
            journies = []
            #endif
            
            return
        }
        // 2. year, month 추출
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        
        // 3. 월별 여정 데이터 API 호출
        let result = await BabyMoaService.shared.getGetJourniesAtMonth(
            babyId: babyId,
            year: year,
            month: month
        )
        
        switch result {
        case .success(let response):
            guard let models = response.data else {
                journies = []
                return
            }
            
            // ResponseModel → Domain 변환
            var converted: [Journey] = []
            for model in models {
                let journey = await model.toDomain()
                converted.append(journey)
            }
            
            // UI 상태 업데이트
            journies = converted
            
        case .failure(let error):
            print("❌ 여정 조회 실패:", error)
            
            // 개발 환경에서는 Mock 데이터로 대체
            #if DEBUG
            print("📦 개발 환경: Mock 데이터 \(Journey.mockData.count)개 로드")
            journies = Journey.mockData
            #else
            journies = []
            #endif
        }
    }
}
