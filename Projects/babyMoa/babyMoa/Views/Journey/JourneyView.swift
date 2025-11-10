//
//  JourneyView.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//

import SwiftUI

struct JourneyView: View {
    let coordinator: BabyMoaCoordinator
    @State private var viewModel: JourneyViewModel
    @State private var calendarViewModel: CalendarViewModel
    //@Observable 쓰면서 @StateObject 가 ->  @State로 바뀜 재생성 안됨 해당 뷰 인스턴스의 수명동안 저장소 유지 다른 뷰로 간주될 떄만 초기화 일어남 부모가 id를 바꾸거나.. 전혀 다른 라우팅으로 동일타입의 뷰를 생성한다면. 새로운 아이덴티가 일어나서 초기화됨
    
    // ToDo : 저니뷰모델에 중복호출 방지만 해주자
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        _viewModel = State(initialValue: JourneyViewModel(coordinator: coordinator))
        _calendarViewModel = State(initialValue: CalendarViewModel(coordinator: coordinator))
        print("✅ JourneyView init 호출됨")
    }
        
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    // 달력 카드
                    CalendarCard(
                        viewModel: calendarViewModel,  //  @ObservedObject 전달
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
        .onAppear { // MARK: 테스트 코드입니다. 삭제 필요 (Ted 맘대로 추가한 거)
            Task {
                await viewModel.fetchJournies(year: 2025, month: 11)
                calendarViewModel.journies = viewModel.journies
            }
        }
    }
}

// MARK: - Preview

#Preview {
    JourneyView(coordinator: BabyMoaCoordinator())
}

