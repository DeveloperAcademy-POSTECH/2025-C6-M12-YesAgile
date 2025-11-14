//
//  JourneyView.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//

// JourneyView.swift
import SwiftUI

struct JourneyView: View {
    let coordinator: BabyMoaCoordinator
    @State private var viewModel: JourneyViewModel
    @State private var calendarCardViewModel: CalendarCardViewModel

    // MARK: - Sheet State (여정 추가 화면 표시용)

    /// 여정 추가 화면 표시 여부
    @State private var showAddJourney = false

    /// 선택된 날짜 (여정 추가 시 사용)
    @State private var selectedDateForAdd: Date?

    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator

        // JourneyViewModel 객체 생성
        let journeyViewModel = JourneyViewModel(coordinator: coordinator)
        _viewModel = State(initialValue: journeyViewModel)

        // CalendarViewModel에 주소 전달
        _calendarCardViewModel = State(
            initialValue: CalendarCardViewModel(
                coordinator: coordinator,
                journeyViewModel: journeyViewModel
            )
        )

        print("✅ JourneyView init 호출됨")
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    // 달력 카드
                    CalendarCard(
                        viewModel: calendarCardViewModel,
                        showAddJourney: $showAddJourney,
                        selectedDateForAdd: $selectedDateForAdd
                    )
                    .padding(.horizontal, 20)

                    // 지도 카드
                    MapCard()
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 30)
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchJournies(year: 2025, month: 11)
                calendarCardViewModel.updateMonthDates()
            }
        }
        // MARK: - 여정 추가 (Full Screen) 자꾸 흰화면이나와서
        .fullScreenCover(
            isPresented: Binding(
                get: { showAddJourney && selectedDateForAdd != nil },
                set: { newValue in
                    showAddJourney = newValue
                    if !newValue {
                        selectedDateForAdd = nil
                    }
                }
            )
        ) {
            if let date = selectedDateForAdd {
                JourneyAddView(
                    coordinator: nil,
                    selectedDate: date,
                    onSave: { image, memo in
                        Task {
                            let newJourney = Journey(
                                journeyId: Int.random(in: 100...999),
                                journeyImage: image,
                                latitude: 37.5665,
                                longitude: 126.9780,
                                date: date,
                                memo: memo.isEmpty ? "메모 없음" : memo
                            )

                            await viewModel.addJourney(newJourney)
                        }
                    }
                )
                .onDisappear {
                    selectedDateForAdd = nil
                    showAddJourney = false
                }
            } else {
                Color.clear
            }
        }
    }
}

#Preview {
    JourneyView(coordinator: BabyMoaCoordinator())
}
