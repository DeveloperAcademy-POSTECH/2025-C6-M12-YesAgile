//
//  MapCardViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/8/25.
//

import Foundation
import SwiftUI

/// MapCard의 비즈니스 로직 처리 ,위치 유효성 검증, 날짜별 대표 여정 선택
class MapCardViewModel {

    // MARK: - 대표 여정 선택
    // 상태 저장 않고 계산 역할만
    func representativeJournies(from journies: [Journey]) -> [Journey] {
        // 1. 위치 정보가 유효한 여정만 필터링 (Journey.hasValidLocation 사용) 위치/경도 0 인데이터 찍으면 안되니까
        let validJournies = journies.filter { journey in
            journey.hasValidLocation
        }

        var result: [Journey] = []
        var seenDates: Set<Date> = []  // 대표로 뽑은 날짜들을 저장해둘 Set을 만든다!!

        // 2. 날짜별로 첫 번째 여정만 선택
        for journey in validJournies {
            let dateOnly = Calendar.current.startOfDay(for: journey.date)

            if !seenDates.contains(dateOnly) {  // 이 날짜가 아직 대표로 뽑히지 않았는지 확인
                seenDates.insert(dateOnly)  // 처음 등장하는 날짜라면 Set에 기록
                result.append(journey)  // 첫 번째 = 가장 먼저 추가된 것, 첫번째 여정을 대표로 result 추가
            }
        }

        return result  // 대표여정들만 담긴 배열을 반환
    }

    // MARK: - 특정 날짜 조회

    /// 특정 날짜의 모든 여정 조회 (최신순 정렬)
    func journies(for date: Date, from journies: [Journey]) -> [Journey] {
        journies  // 저니스의 배열을 가져옴
            .filter { journey in
                journey.date.isSameDay(as: date)
            }
            .sorted { firstJourney, secondJourney in
                firstJourney.date > secondJourney.date  // 최신순
            }
    }
}
