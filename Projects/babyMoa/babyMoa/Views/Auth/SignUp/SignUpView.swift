//
//  SignUpView.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import AuthenticationServices
import SwiftUI

struct SignUpView: View {
    @State var viewModel: SignUpViewModel
    @Environment(\.dismiss) var dismiss
    
    init(coordinator: BabyMoaCoordinator) {
        viewModel = SignUpViewModel(coordinator: coordinator)
    }
    
    var body: some View {
        VStack(spacing: 0) {
//            TermsAgreementHeaderView(cancelAction: {
//                viewModel.coordinator.pop()
//            })
//            .padding(.bottom, 60)
            TermsAgreementView(termCheckList: $viewModel.termCheckList)
                .padding(.bottom, 20)
            if viewModel.isAllChecked() {
                SignInWithAppleButton(.signIn) { request in
                    viewModel.handleRequest(request: request)
                } onCompletion: { result in
                    Task {
                        await viewModel.handleCompletion(result: result)
                        //  로그인 성공 후 시트 닫기
                        dismiss() // 시트를 닫습니다.
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .cornerRadius(10)
                .padding()
            }
            Spacer()
        }
        .sheet(isPresented: $viewModel.isShowingPrivacySheet) {
            PrivacyConsentView(coordinator: viewModel.coordinator)
        }
        .presentationDetents([.height(370)])
        .presentationCornerRadius(25)
        .presentationDragIndicator(.visible)
    }
    
}


#Preview {
    // SignUpView는 'coordinator'를 필요로 합니다.
    SignUpView(
        coordinator: BabyMoaCoordinator() // 매개변수 없이 초기화
    )
}
