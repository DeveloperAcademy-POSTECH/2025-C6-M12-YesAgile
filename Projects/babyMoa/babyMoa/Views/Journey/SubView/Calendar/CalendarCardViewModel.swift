//
//  CalendarViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//

import SwiftUI

/// 달력 화면의 비즈니스 로직 관리
/// - Note: ViewModel은 순수 비즈니스 로직만 담당 (네비게이션 책임 제거)
@MainActor
@Observable
class CalendarCardViewModel {
    var journeyVM: JourneyViewModel  // 여정 데이터 참조
    // MARK: - 현재 표시 중인 월 ,선택된 날짜, 현재 월의 모든 날짜 (42일 = 6주), 여정 리스트 (JourneyViewModel에서 가져옴)
    var currentMonth: Date = Date()
    var selectedDate: Date = Date()
    var monthDates: [Date] = []
    var journies: [Journey] {
        journeyVM.journies
    }
    /// - Parameter journeyViewModel: 여정 데이터를 관리하는 ViewModel
    init(journeyViewModel: JourneyViewModel) {
        self.journeyVM = journeyViewModel
        updateMonthDates()
    }

    // MARK: - 날짜 계산 로직 (View에서 이동 함)
    /// 현재 월의 42일 날짜 배열 계산
    /// - Note: 6주 = 42일 (이전 월 끝 ~ 다음 월 시작 포함)
    func updateMonthDates() {
        guard
            let monthInterval = Calendar.current.dateInterval(
                of: .month,
                for: currentMonth
            ),
            let monthFirstWeek = Calendar.current.dateInterval(
                of: .weekOfMonth,
                for: monthInterval.start
            )
        else {
            monthDates = []
            return
        }

        var dates: [Date] = []
        var date = monthFirstWeek.start

        // 6주치 날짜 생성 (42일)
        for _ in 0..<42 {
            dates.append(date)
            guard
                let nextDate = Calendar.current.date(
                    byAdding: .day,
                    value: 1,
                    to: date
                )
            else { break }
            date = nextDate
        }

        monthDates = dates
    }

    // MARK: - 월 네비게이션

    /// 이전 월로 이동
    func previousMonthTapped() {
        guard
            let newMonth = Calendar.current.date(
                byAdding: .month,
                value: -1,
                to: currentMonth
            )
        else { return }
        currentMonth = newMonth
        updateMonthDates()
    }

    /// 다음 월로 이동
    func nextMonthTapped() {
        guard
            let newMonth = Calendar.current.date(
                byAdding: .month,
                value: 1,
                to: currentMonth
            )
        else { return }
        currentMonth = newMonth
        updateMonthDates()
    }

    // MARK: - 날짜 선택

    /// 날짜 탭 시 해당 날짜의 여정 반환
    /// - Parameter date: 선택된 날짜
    /// - Returns: 해당 날짜의 여정 배열
    func dateTapped(_ date: Date) -> [Journey] {
        // 1. 선택된 날짜 업데이트 (달력에서 해당 날짜가 하이라이트됨)
        selectedDate = date

        // 2. 탭한 날짜와 동일한 날짜의 여정만 필터링하여 반환
        let result = journies.filter { journey in
            journey.date.isSameDay(as: date)
        }

        return result
    }

    // MARK: - Helper Methods (View에서 이동함)

    /// 날짜가 현재 월에 속하는지
    func isInCurrentMonth(_ date: Date) -> Bool {
        Calendar.current.isDate(
            date,
            equalTo: currentMonth,
            toGranularity: .month
        )
    }

    /// 날짜가 선택되었는지
    func isSelected(_ date: Date) -> Bool {
        date.isSameDay(as: selectedDate)
    }

    // MARK: - Private Helpers

    private func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
