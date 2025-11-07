//
//  BabyMainView.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import SwiftUI

struct BabyMainView: View {
    
    @ObservedObject var viewModel: BabyMainViewModel
    @State private var sheetHeight: CGFloat = .zero
    
    var coordinator: BabyMoaCoordinator
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    if let baby = viewModel.selectedBaby {
                        BabyHeaderView(
                            babyName: baby.name,
                            buttonType: .none, // 기본값으로 설정 버튼 사용
                            onButtonTap: {
                                
                                /* TODO: 설정 버튼 액션 구현 */
                                
                            }
                        )
                        .onTapGesture {
                            viewModel.showBabyListSheet()
                        }
                     
                        BabyProfileCard(coordinator: coordinator, baby: baby)
                        
                    } else {
                        // TODO: 아기가 없는 경우의 UI 처리
                        Text("아기를 추가해주세요.")
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
                        coordinator.push(path: .addBabyCreate)
                    }
                    
                    Button("로그아웃", action: {
                        // TODO: 로그아웃 기능 구현
                        viewModel.showSignOutAlert = true
                    })
                    .buttonStyle(.outlineThirdButton)
                    
                    Spacer()
                }
                .backgroundPadding(.horizontal)
            }
        }
        
        .sheet(isPresented: $viewModel.isShowingSheet) {
            BabyListView(babies: viewModel.babies, onSelectBaby: { baby in
                viewModel.selectBaby(baby)
            }, onAddBaby: {
                coordinator.push(path: .addBabyCreate)
            })
            .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                if newHeight > 0 {
                    sheetHeight = newHeight
                    print("Calculated sheet height: \(newHeight)")
                }
            }
            .presentationDetents(
                sheetHeight > 0 ? [.height(sheetHeight)] : [.medium]
            )
            .presentationCornerRadius(25)
            .presentationDragIndicator(.visible)
        }
        .alert("오류", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
            Button("확인") { }
        } message: {
            Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.")
        }
        .alert("로그아웃할까요?", isPresented: $viewModel.showSignOutAlert, actions: {
            Button("로그아웃", role: .destructive) {
                
                if viewModel.signOut() {
                     // sessionManager.sessionState = .loggedOut 에서 로그아웃을 처리해야 되나 어떻게 해야 되나?
                    // 서버와 이야기 해야 한다.
                    print("로그인 버튼을 클릭했습니다.")
                }
                
            }
            Button("취소", role: .cancel) {
                
            }
            
        })
    }
}



#Preview {
    BabyMainView(
        viewModel: BabyMainViewModel(alertManager: AlertManager()),
        coordinator: BabyMoaCoordinator()
    )
}
