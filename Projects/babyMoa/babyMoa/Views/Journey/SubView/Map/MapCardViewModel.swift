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
    
    // MARK: - 위치 유효성 검증
    
    /// 위치 정보가 유효한지 확인 (지도에 표시 가능한지)
    /// - Parameter journey: 검증할 여정
    /// - Returns: 유효하면 true (0,0 제외, GPS 범위 내)
    private func hasValidLocation(_ journey: Journey) -> Bool {
        journey.latitude != 0 && journey.longitude != 0 &&
        journey.latitude >= -90 && journey.latitude <= 90 &&
        journey.longitude >= -180 && journey.longitude <= 180
    }
    
    // MARK: - 대표 여정 선택
    
    /// 같은 날짜의 여정 중 첫 번째(가장 먼저 추가된) 여정을 대표로 선택
    /// - Parameter journies: 원본 여정 배열 (JourneyViewModel에서 받음)
    /// - Returns: 날짜별 대표 여정 배열 (지도 마커용)
    /// - Note: 위치 정보가 유효한 여정만 포함
    func representativeJournies(from journies: [Journey]) -> [Journey] {
        // 1. 위치 정보가 유효한 여정만 필터링
        let validJournies = journies.filter { hasValidLocation($0) }
        
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
            .filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date > $1.date }  // 최신순
    }
}
