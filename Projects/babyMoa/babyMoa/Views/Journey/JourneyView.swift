//
//  JourneyView.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//

import SwiftUI

struct JourneyView: View {
    let coordinator: BabyMoaCoordinator
    @State var calendarViewModel: CalendarViewModel  //  ViewModel 추가
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        self.calendarViewModel = CalendarViewModel(coordinator: coordinator)
        print("✅ JourneyView init 호출됨")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    // 달력 카드
                    CalendarCard(
                        viewModel: $calendarViewModel,  //  @Binding 전달
                        journies: []  // TODO: JourneyViewModel에서 받을 예정
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
    }
}

// MARK: - Preview

#Preview {
    JourneyView(coordinator: BabyMoaCoordinator())
}

