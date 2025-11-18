//
//  MapCardViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/8/25.
//

import SwiftUI
import Foundation

/// MapCard의 비즈니스 로직 처리
/// - 위치 유효성 검증
/// - 날짜별 대표 여정 선택
/// - Note: 데이터는 파라미터로 받아서 처리만 함 (상태 저장 안 함)
///   → Single Source of Truth: JourneyViewModel.journies
///   → 데이터 중복 제거, 자동 동기화
class MapCardViewModel {
    
    // MARK: - 대표 여정 선택
    
    /// 같은 날짜의 여정 중 첫 번째(가장 먼저 추가된) 여정을 대표로 선택
    /// - Parameter journies: 원본 여정 배열 (JourneyViewModel에서 받음)
    /// - Returns: 날짜별 대표 여정 배열 (지도 마커용)
    /// - Note: 위치 정보가 유효한 여정만 포함
    func representativeJournies(from journies: [Journey]) -> [Journey] {
        // 1. 위치 정보가 유효한 여정만 필터링 (Journey.hasValidLocation 사용)
        let validJournies = journies.filter { journey in
            journey.hasValidLocation
        }
        
        var result: [Journey] = []
        var seenDates: Set<Date> = []
        
        // 2. 날짜별로 첫 번째 여정만 선택
        for journey in validJournies {
            let dateOnly = Calendar.current.startOfDay(for: journey.date)
            
            if !seenDates.contains(dateOnly) {
                seenDates.insert(dateOnly)
                result.append(journey)  // 첫 번째 = 가장 먼저 추가된 것
            }
        }
        
        return result
    }
    
    // MARK: - 특정 날짜 조회
    
    /// 특정 날짜의 모든 여정 조회 (최신순 정렬)
    /// - Parameters:
    ///   - date: 조회할 날짜
    ///   - journies: 원본 여정 배열 (JourneyViewModel에서 받음)
    /// - Returns: 해당 날짜의 여정 배열 (최신순)
    func journies(for date: Date, from journies: [Journey]) -> [Journey] {
        journies
            .filter { journey in
                journey.date.isSameDay(as: date)
            }
            .sorted { firstJourney, secondJourney in
                firstJourney.date > secondJourney.date  // 최신순
            }
    }
}
