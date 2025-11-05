//
//  BabyMainView.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import SwiftUI

struct BabyMainView: View {
    
    @StateObject private var viewModel = BabyMainViewModel()
    @State private var sheetHeight: CGFloat = .zero
    
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
                            buttonType: .navigate, // 기본값으로 설정 버튼 사용
                            onButtonTap: {
                                
                                /* TODO: 설정 버튼 액션 구현 */
                                
                            }
                        )
                        .onTapGesture {
                            viewModel.showBabyListSheet()
                        }
                     
                        BabyProfileCard(baby: baby)
                        
                    } else {
                        // TODO: 아기가 없는 경우의 UI 처리
                        Text("아기를 추가해주세요.")
                    }
                    
                    // Components: 양육자 및 아기 관리 버튼
                    BabyMainRowView(title: "양육자", buttonLabel: "공동 양육자 초대") {
                        // print
                        print("버튼클릭했어요")
                    }
                    
                    BabyMainRowView(title: "아기", buttonLabel: "아기 추가") {
                        // print
                        print("버튼클릭했어요")
                    }
                    
                    Button("로그아웃", action: {
                        // TODO: 로그아웃 기능 구현
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
            })
            .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                if newHeight > 0 {
                    sheetHeight = newHeight
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
    }
}



#Preview {
    BabyMainView()
}
