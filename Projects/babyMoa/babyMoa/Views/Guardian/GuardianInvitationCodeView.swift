//
//  GuardianInvitationCodeView.swift
//  babyMoa
//
//  Created by Baba on 10/22/25.
//

import SwiftUI

struct GuardianInvitationCodeView: View {
    
    @State var relationShip = ""
    
    var body: some View {
        VStack{
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.0))
                .clipShape(Circle())
            
            
            Text("응애자일 - Baby Name")
                .padding(.top, 10)
            Text("2025. 09. 01 출생")
                .padding(.top, 10)
            
            VStack(alignment: .leading){
                
                Text("아이와의 관계")
                // 아이와의 관계를 컴포넌트화 사용한다.
                // 모델에서 데이터를 받아서 전달하는 형태가 되어야 한다.
                TextField("아이와의 관계", text: $relationShip)
                    .textFieldStyle(.basicForm)
                    .padding(.bottom, 10)
                
                Button(action: {
                    
                }, label: {
                    Text("공동양육자 초대 코드 생성")
                        .authButtonTextStyle(bgColor: .blue)
                })
            }
            .padding(.top, 16)
            
            
            Spacer()
        }
        .padding(16)
    }
}

#Preview {
    GuardianInvitationCodeView()
}
