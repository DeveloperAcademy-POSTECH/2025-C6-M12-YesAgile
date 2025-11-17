//
//  JourneyView.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//

// JourneyView.swift
import SwiftUI

struct JourneyView: View {
    // MARK: - View가 화면 전환 책임을 가짐 (ViewModel은 순수 비즈니스 로직만)
    let coordinator: BabyMoaCoordinator

    @State private var journeyVM: JourneyViewModel
    @State private var calendarCardVM: CalendarCardViewModel

    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        let journeyViewModel = JourneyViewModel()
        _journeyVM = State(initialValue: journeyViewModel)
        _calendarCardVM = State(
            initialValue: CalendarCardViewModel(
                journeyViewModel: journeyViewModel
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 달력 카드 직접 뷰모델을 통해 값을 주입
                CalendarCard(
                    data: CalendarCardData(
                        currentMonth: calendarCardVM.currentMonth,
                        monthDates: calendarCardVM.monthDates,
                        selectedDate: calendarCardVM.selectedDate,
                        journies: calendarCardVM.journies
                    ),
                    actions: CalendarCardActions(
                        onPreviousMonth: {
                            calendarCardVM.previousMonthTapped()
                            
                            Task {
                                await journeyVM.fetchJournies(for: calendarCardVM.currentMonth)
                            }
                        },
                        onNextMonth: {
                            calendarCardVM.nextMonthTapped()
                            
                            Task {
                                await journeyVM.fetchJournies(for: calendarCardVM.currentMonth)
                            }
                        },
                        // 날짜 탭 시 화면 전환 로직을 View에서 처리
                        onDateTap: { date in
                            // ViewModel에서 날짜 선택 + 여정 조회 한 번에 처리
                            let journiesForDate = calendarCardVM.dateTapped(date)

                            // 여정 존재 여부에 따라 화면 전환
                            if journiesForDate.isEmpty {
                                // 여정 없음 → 추가 화면
                                coordinator.push(path: .journeyAdd(date: date))
                                print("➕ 여정 추가 화면 이동: \(date.yyyyMMdd)")
                            } else {
                                // 여정 있음 → 리스트 화면
                                coordinator.push(
                                    path: .journeyList(
                                        date: date,
                                        journies: journiesForDate
                                    )
                                )
                                print(
                                    "📋 여정 리스트 화면 이동: \(date.yyyyMMdd), \(journiesForDate.count)개"
                                )
                            }
                        },
                        isInCurrentMonth: {
                            calendarCardVM.isInCurrentMonth($0)
                        },
                        isSelected: { date in
                            let result = calendarCardVM.isSelected(date)
                            return result  // true 또는 false
                        }
                        //          ↑ 여기서 함수를 전달!
                               //          { $0 } = 는 클로저 축약 문법
                               
                    )
                )
                .padding(.horizontal, 20)
                // 지도 카드
                MapCard(journies: journeyVM.journies)
                    .padding(.horizontal, 20)
                Spacer().frame(height: 30)
            }
            .padding(.top, 20)
        }
        .onAppear {
            Task {
                await journeyVM.fetchJournies(for: calendarCardVM.currentMonth)
            }
        }
    }
}

#Preview {
    JourneyView(coordinator: BabyMoaCoordinator())
}
