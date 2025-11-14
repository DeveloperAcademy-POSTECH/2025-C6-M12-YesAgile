//
//  CalendarViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//

import SwiftUI

/// 달력 화면의 비즈니스 로직 관리
@Observable
class CalendarCardViewModel {
    var coordinator: BabyMoaCoordinator
    var journeyViewModel: JourneyViewModel  // 참조만 하게끔 수정

    // MARK: - Properties

    /// 현재 표시 중인 월
    var currentMonth: Date = Date()

    /// 선택된 날짜
    var selectedDate: Date = Date()

    /// 현재 월의 모든 날짜 (42일 = 6주)
    var monthDates: [Date] = []

    var journies: [Journey] {
        journeyViewModel.journies
    }

    // MARK: - Initialization

    init(coordinator: BabyMoaCoordinator, journeyViewModel: JourneyViewModel) {
        self.coordinator = coordinator
        self.journeyViewModel = journeyViewModel
        updateMonthDates()
        print("✅ CalendarViewModel init 호출됨")
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
        print(
            "✅ CalendarViewModel: \(monthDates.count)개 날짜 생성 (\(formatMonth(currentMonth)))"
        )
    }

    // TODO: 테스트 코드, 삭제 필요 (Ted 맘대로 추가한 거)
    //    func addJourney() async {
    //        // api 결과라 생각
    //        journies = Journey.mockData
    //    }

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
        print("📅 이전 월: \(formatMonth(currentMonth))")
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
        print("📅 다음 월: \(formatMonth(currentMonth))")
    }

    // MARK: - 날짜 선택

    /// 날짜 셀 탭 이벤트
    /// - Parameter date:
    /// - Parameter showAddJourney:
    /// - Parameter selectedDateForAdd:
    @MainActor
    func dateTapped(
        _ date: Date,
        showAddJourney: Binding<Bool>,
        selectedDateForAdd: Binding<Date?>
    ) {
        selectedDate = date //
        print("📅 날짜 선택: \(formatDate(date))")

        let journiesForDate = journies.filter { journey in
            Calendar.current.isDate(journey.date, inSameDayAs: date)
        }
        if journiesForDate.isEmpty {
            selectedDateForAdd.wrappedValue = date
            showAddJourney.wrappedValue = true
            print("➕ 여정 추가 Sheet 표시: \(formatDate(date))")
        } else {
            // 여정 있음 → 리스트 화면 (Coordinator)
            coordinator.push(
                path: .journeyList(date: date, journies: journiesForDate)
            )
            print(
                "📋 여정 리스트 화면 이동: \(formatDate(date)), \(journiesForDate.count)개"
            )
        }
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
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }

    //목 데이터 주입
    //    func loadMock() {
    //        journeyVM = Journey.mockData
    //      updateMonthDates()
    //    }

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
