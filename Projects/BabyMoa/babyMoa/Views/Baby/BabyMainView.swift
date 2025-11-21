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
                
               
                
                // 계정 타이틀
                Text("계정")
                    .font(.system(size: 14, weight: .medium))
                    .padding(.leading, 4) // 타이틀에 약간의 여백을 주면 더 자연스럽습니다 (선택)

                VStack(spacing: 0) {
                    //MARK: - 1. 로그아웃 버튼
                    Button(action: {
                        viewModel.showSignOutAlert = true
                    }, label: {
                        Text("로그아웃")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.font)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                    })
                    // 구분선
                    Divider()
                        .padding(.horizontal, 16) // 좌우 여백을 텍스트와 맞춤 (선택사항)
                    //MARK: - 2. 탈퇴하기 버튼
                    Button(action: {
                        coordinator.push(path: .accountDeleteConfirmView)
                    }, label: {
                        HStack {
                            Text("탈퇴하기")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.font)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.font)
                                .font(.system(size: 14))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                    })
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
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


