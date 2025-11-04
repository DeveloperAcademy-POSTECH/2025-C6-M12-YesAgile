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
    
    init(coordinator: BabyMoaCoordinator) {
        viewModel = SignUpViewModel(coordinator: coordinator)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TermsAgreementHeaderView(cancelAction: {
                viewModel.coordinator.pop()
            })
            .padding(.bottom, 60)
            TermsAgreementView(termCheckList: $viewModel.termCheckList)
                .padding(.bottom, 20)
            if viewModel.isAllChecked() {
                SignInWithAppleButton(.signIn) { request in
                    viewModel.handleRequest(request: request)
                } onCompletion: { result in
                    Task {
                        await viewModel.handleCompletion(result: result)
                        
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .cornerRadius(10)
                .padding()
            }
            Spacer()
        }
    }
}


