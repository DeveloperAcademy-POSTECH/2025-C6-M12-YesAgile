//
//  CalendarViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//

import SwiftUI

/// 달력 화면의 비즈니스 로직 관리
@Observable
class CalendarViewModel {
    var coordinator: BabyMoaCoordinator
    var journies: [Journey] = []
    
    // MARK: - Properties
    
    /// 현재 표시 중인 월
    var currentMonth: Date = Date()
    
    /// 선택된 날짜
    var selectedDate: Date = Date()
    
    /// 현재 월의 모든 날짜 (42일 = 6주)
    var monthDates: [Date] = []
    
    // MARK: - Initialization
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        self.journies = journies
        updateMonthDates()
        print("✅ CalendarViewModel init 호출됨")
    }
    
    // MARK: - 날짜 계산 로직 (View에서 이동 함)
    
    /// 현재 월의 42일 날짜 배열 계산
    /// - Note: 6주 = 42일 (이전 월 끝 ~ 다음 월 시작 포함)
    func updateMonthDates() {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            monthDates = []
            return
        }
        
        var dates: [Date] = []
        var date = monthFirstWeek.start
        
        // 6주치 날짜 생성 (42일)
        for _ in 0..<42 {
            dates.append(date)
            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = nextDate
        }
        
        monthDates = dates
        print("✅ CalendarViewModel: \(monthDates.count)개 날짜 생성 (\(formatMonth(currentMonth)))")
    }
    
    // TODO: 테스트 코드, 삭제 필요 (Ted 맘대로 추가한 거)
//    func addJourney() async {
//        // api 결과라 생각
//        journies = Journey.mockData
//    }
    
    // MARK: - 월 네비게이션
    
    /// 이전 월로 이동
    func previousMonthTapped() {
        guard let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) else { return }
        currentMonth = newMonth
        updateMonthDates()
        print("📅 이전 월: \(formatMonth(currentMonth))")
    }
    
    /// 다음 월로 이동
    func nextMonthTapped() {
        guard let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) else { return }
        currentMonth = newMonth
        updateMonthDates()
        print("📅 다음 월: \(formatMonth(currentMonth))")
    }
    
    // MARK: - 날짜 선택
    
    /// 날짜 셀 탭 이벤트
    func dateTapped(_ date: Date) {
        selectedDate = date
        print("📅 날짜 선택: \(formatDate(date))")
        // TODO: 상세 화면 이동
        // coordinator.push(path: .journeyList(date: date))
    }
    
    // MARK: - Helper Methods (View에서 이동함)
    
    /// 날짜가 현재 월에 속하는지
    func isInCurrentMonth(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    /// 날짜가 선택되었는지
    func isSelected(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    /// 날짜에 Journey가 있는지
    func hasJourney(_ date: Date, journies: [Journey]) -> Bool {
        journies.contains { journey in
            Calendar.current.isDate(journey.date, inSameDayAs: date)
        }
    }
    
    // MARK: - Private Helpers
    
    private func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}
