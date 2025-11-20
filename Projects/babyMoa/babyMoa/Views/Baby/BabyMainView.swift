//
//  BabyMainView.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import SwiftUI

struct BabyMainView: View {
    
    @ObservedObject var viewModel: BabyMainViewModel
    
    var coordinator: BabyMoaCoordinator
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                if let baby = viewModel.selectedBaby {
                    BabyProfileCard(coordinator: coordinator, baby: baby)
                }
                
                // Components: 양육자 및 아기 관리 버튼
                BabyMainRowView(title: "양육자", buttonLabel: "공동 양육자 초대") {
                    // print
                    print("버튼클릭했어요 공동양육자 초대 코드 생성")
                    coordinator.push(path: .guardain)
                }
                
                BabyMainRowView(title: "아기", buttonLabel: "아기 추가") {
                    // print
                    print("버튼클릭했어요")
                    coordinator.push(path: .addBaby)
                }
                
                Button("로그아웃", action: {
                    // TODO: 로그아웃 기능 구현
                    viewModel.showSignOutAlert = true
                })
                .buttonStyle(.outlineThirdButton)
                
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .backgroundPadding(.horizontal)
        .background(Color.background)

        
        .alert("로그아웃할까요?", isPresented: $viewModel.showSignOutAlert, actions: {
            Button("로그아웃", role: .destructive) {
                viewModel.signOut()
            }
            Button("취소", role: .cancel) {}
        })
    }
}

#Preview {
    let coordinator = BabyMoaCoordinator()
    return BabyMainView(
        viewModel: BabyMainViewModel(coordinator: coordinator),
        coordinator: coordinator
    )
}


