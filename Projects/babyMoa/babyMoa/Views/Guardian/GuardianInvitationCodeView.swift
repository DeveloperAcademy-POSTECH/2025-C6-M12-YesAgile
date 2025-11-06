//
//  GuardianInvitationCodeView.swift
//  babyMoa
//
//  Created by Baba on 10/22/25.
//

import SwiftUI

struct GuardianInvitationCodeView: View {
    
    @StateObject private var viewModel: GuardianInvitationCodeViewModel
    
    init(viewModel: GuardianInvitationCodeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 20){
                CustomNavigationBar(title: "공동 육아자 초대", leading: {
                    // TODO: 이전 화면으로 돌아가는 로직 구현
                    // Button으로 구현하면 된다.
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "chevron.left")

                    })
                })
                
                // TODO: ViewModel에서 실제 아기 프로필 이미지 가져오기
                BabyProfileImageView()
                
                VStack{
                    Text(viewModel.babyName)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.bottom, 13)
                    Text("\(viewModel.birthDateLabel) 출생")
                        .font(.system(size: 14, weight: .medium))
                }
                
                RelationshipSelectionView(
                    relationship: $viewModel.relationship,
                    showRelationshipPicker: $viewModel.showRelationshipPicker
                )
                
                VStack(alignment: .leading){
                    Button("공동 양육자 초대 코드 생성", action: {
                        Task {
                            await viewModel.generateInvitationCode()
                        }
                    })
                    .buttonStyle(.defaultButton)
                    // 로딩 중일 때 버튼 비활성화
                    .disabled(viewModel.isLoading)
                }
                Spacer()
            }
            .backgroundPadding(.horizontal)
            
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .alert("오류", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
            Button("확인") { }
        } message: {
            Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.")
        }
    }
}

#Preview {
    GuardianInvitationCodeView(viewModel: GuardianInvitationCodeViewModel())
}
