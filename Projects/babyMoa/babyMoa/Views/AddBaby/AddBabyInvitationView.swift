//
//  AddBabyInvitationView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI

struct AddBabyInvitationView: View {
    
    @State var invitationCode: String = ""
    
    var body: some View {
        VStack{
            // --- 타이틀 ---
            Text("addBabyInvitation.title")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40) // 화면 상단 여백
            
            // --- 설명 ---
            Text("addBabyInvitation.description")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.top, 10)
                .padding(.bottom, 20) // 텍스트필드와의 여백
            
            // --- 텍스트필드 ---
            TextField("addBabyInvitation.textField.placeholder", text: $invitationCode)
                .textFieldStyle(.basicForm)
                .multilineTextAlignment(.center)
            
            Button(action: {
                
            }, label: {
                Text("textOk")
                    .authButtonTextStyle(bgColor: .blue)
            })
            
            Spacer() // 나머지 공간을 모두 밀어냄
        }
        .padding(16)
    }
}

#Preview {
    AddBabyInvitationView()
}
