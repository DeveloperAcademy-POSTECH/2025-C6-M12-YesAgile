//
//  JourneyCalendarViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//

import SwiftUI

@MainActor
@Observable
class JourneyCalendarViewModel {
    // MARK: - Properties
    var currentMonth: Date = Date()
    var selectedDate: Date = Date()
    var monthDates: [Date] = []
    
    init() {
        updateMonthDates()
    }
    
    // MARK: - Date Calculation
    func updateMonthDates() {
        var dates: [Date] = []
        guard
            let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth),
            let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else {
            monthDates = []
            return
        }
        
        var date = monthFirstWeek.start
        for _ in 0..<42 {
            dates.append(date)
            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = nextDate
        }
        monthDates = dates
    }
    
    // MARK: - Month Navigation
    func previousMonthTapped() {
        guard let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) else { return }
        currentMonth = newMonth
        updateMonthDates()
    }
    
    func nextMonthTapped() {
        guard let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) else { return }
        currentMonth = newMonth
        updateMonthDates()
    }
    
    // MARK: - Date Selection
    func dateTapped(_ date: Date) {
        selectedDate = date
    }
    
    // MARK: - Helper Methods
    func isInCurrentMonth(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    func isSelected(_ date: Date) -> Bool {
        isSameDay(date: date, as: selectedDate)
    }
    
    private func isSameDay(date: Date, as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: otherDate)
    }
    
    var monthYearString: String {
        // Date+Extensions에 정의된 static formatter 사용 (성능 최적화)
        // 만약 Date+Extensions가 없다면 아래처럼 포맷터를 재사용하는 것이 좋음
        return DateFormatter.yyyyKoreanMonth.string(from: currentMonth)
    }
}
