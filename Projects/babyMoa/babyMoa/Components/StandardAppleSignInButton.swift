//
//  StandardAppleSignInButton.swift
//  babyMoa
//
//  Created by Baba on 10/21/25.
//

import SwiftUI
import AuthenticationServices // Apple 로그인 버튼을 위해 필요

struct StandardAppleSignInButton: View {
    var body: some View {
        SignInWithAppleButton(
            .signIn, // .signUp (회원가입), .continue (계속하기) 등
            onRequest: { request in
                // TODO: 요청(request) 설정
            },
            onCompletion: { result in
                // TODO: 로그인 완료(completion) 처리
            }
        )
        .signInWithAppleButtonStyle(.black) // .white, .whiteOutline
        .frame(height: 50)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    StandardAppleSignInButton()
}
