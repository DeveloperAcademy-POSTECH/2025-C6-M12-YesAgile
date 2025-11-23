//
//  JourneyCalendarViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//  Refactored on 11/22/25 to remove dependency on JourneyViewModel
//

import SwiftUI

/// 달력 화면의 비즈니스 로직 관리 (날짜 계산 전담)
@MainActor
@Observable
final class JourneyCalendarViewModel {
    // MARK: - Properties
    var currentMonth: Date = Date()
    var selectedDate: Date = Date()
    var monthDates: [Date] = []
    
    // 한국 캘린더 설정 (일요일 시작, 한국 로케일)
    private var calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        cal.firstWeekday = 1  // 일요일 = 1, 월요일 = 2, ..., 토요일 = 7
        return cal
    }()
    
    init() {
        updateMonthDates()
    }

    // MARK: - 날짜 계산 로직
    /// 현재 월의 42일 날짜 배열 계산 (6주)
    /// 한국 캘린더 기준 (일요일 시작)으로 정렬
    func updateMonthDates() {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else {
            monthDates = []
            return
        }

        var dates: [Date] = []
        var date = monthFirstWeek.start

        for _ in 0..<42 {
            dates.append(date)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = nextDate
        }

        monthDates = dates
    }

    // MARK: - 월 네비게이션

    func previousMonthTapped() {
        guard let newMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) else { return }
        currentMonth = newMonth
        updateMonthDates()
    }

    func nextMonthTapped() {
        guard let newMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) else { return }
        currentMonth = newMonth
        updateMonthDates()
    }

    // MARK: - 날짜 선택
    
    func selectDate(_ date: Date) {
        selectedDate = date
    }

    // MARK: - Helper Methods

    func isInCurrentMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }

    func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

