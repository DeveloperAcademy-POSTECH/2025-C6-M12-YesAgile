//
//  SignUpView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    var body: some View {
        VStack{
            
            Text("terms.title")
                .font(.system(size: 26, weight: .medium))
                .padding(.bottom, 20)
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    Button {
                    } label: {
                        Image(systemName:  "checkmark.circle.fill" )
                            .imageScale(.large)
                            .font(.system(size: 20))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text("title"))
                    .accessibilityValue(Text("동의함"))
                    
                    Text("terms.ageRequirement")
                    
                    Spacer()
                }
                HStack{
                    Button {
                    } label: {
                        Image(systemName:  "checkmark.circle.fill" )
                            .imageScale(.large)
                            .font(.system(size: 20))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text("title"))
                    .accessibilityValue(Text("동의함"))
                    
                    Text("terms.serviceAgreement")
                    
                    Spacer()
                    
                    Button(action: {
                        print("Click Check Box - Circle")

                    }, label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.tertiary)
                    })
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text("상세 보기"))
                }
                HStack{
                    Button {
                    } label: {
                        Image(systemName:  "checkmark.circle.fill" )
                            .imageScale(.large)
                            .font(.system(size: 20))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text("title"))
                    .accessibilityValue(Text("동의함"))
                    
                    Text("terms.privacyPolicy")
                    
                    Spacer()
                    
                    Button(action: {
                        print("Click Check Box - Circle")

                    }, label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.tertiary)
                    })
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text("상세 보기"))
                }
            }.padding(.bottom, 40)
            
            
            
            SignInWithAppleButton(
                .signUp, // .signUp (회원가입), .continue (계속하기) 등
                onRequest: { request in
                    // TODO: 요청(request) 설정
                },
                onCompletion: { result in
                    // TODO: 로그인 완료(completion) 처리
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

#Preview {
    SignUpView()
}
