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
    @State private var calendarViewModel: CalendarViewModel
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        
        // JourneyViewModel 객체 생성
        let journeyViewModel = JourneyViewModel(coordinator: coordinator)
        _viewModel = State(initialValue: journeyViewModel)
        
        // CalendarViewModel에 주소 전달
        _calendarViewModel = State(initialValue: CalendarViewModel(
            coordinator: coordinator,
            journeyViewModel: journeyViewModel
        ))
        
        print("✅ JourneyView init 호출됨")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    // 달력 카드
                    CalendarCard(
                        viewModel: calendarViewModel,
                      
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
                calendarViewModel.updateMonthDates()
            }
        }
    }
}

#Preview {
    JourneyView(coordinator: BabyMoaCoordinator())
}
