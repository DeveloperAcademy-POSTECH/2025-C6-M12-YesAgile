//
//  SignInView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    
     func handleSignInWithApple(_ authorization: ASAuthorization){
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("appleIDCredential error")
            return
        }
        
        guard let identityTokenData = appleIDCredential.identityToken else {
            print("identityTokenData error")
            return
        }
        
        guard let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            print("identityToken error")
            return
        }
         
         guard let authorizationCodeData = appleIDCredential.authorizationCode else {
             print("authorizationCodeData error")
             return
         }
         
         guard let _ = String(data: authorizationCodeData, encoding: .utf8) else {
             print("authorizationCode error")
             return
         }
         
        
        print("Click The Apple Login Button")
    }
    
    var body: some View {
        ZStack{
            VStack{
                Text("appName")
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 64)
                
                Text("login.description")
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(.bottom, 50)
                
                SignInWithAppleButton(
                            .signIn, // .signUp (회원가입), .continue (계속하기) 등
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            },
                            onCompletion: { result in
                                // TODO: 로그인 완료(completion) 처리
                                switch result {
                                case .success(let authorization):
                                    // 응답 성공 시 처리
                                    // NOTE: 오타 수정 - handleSignInSucess -> handleSignInWithApple
                                    handleSignInWithApple(authorization)
                                    print("Successfully signed in with \(authorization)")
                                
                                case .failure(let error):
                                    print("Sign in with Apple failed: \(error)")
                                }
                            }
                        )
                        .signInWithAppleButtonStyle(.black) // .white, .whiteOutline
                        .frame(height: 50)
                        .cornerRadius(8)
                
                Spacer()
            }
            .padding(16)
        }
    }
}



#Preview {
    SignInView()
}
