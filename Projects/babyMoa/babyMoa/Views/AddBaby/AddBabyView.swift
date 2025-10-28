//
//  AddBabyView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI

struct AddBabyView: View {
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("addBaby.new.title")
                        .titleTextStyle()
                    
                    Text("addBaby.new.description")
                        .subTitleTextStyle()
                    
                    // "새로운 아기 추가" 버튼 → AddCreateBabyView
                    NavigationLink(destination: AddCreateBabyView()) {
                        Text("addBaby.new.button")
                            .authButtonTextStyle(bgColor: .gray)
                    }
                }
                
                VStack {
                    Text("addBaby.connect.title")
                        .titleTextStyle()
                    
                    Text("addBaby.connect.description")
                        .subTitleTextStyle()
                    
                    // TODO: "초대 코드로 연결" 버튼
                    Button(action: {
                        // 초대 코드 화면으로 이동
                    }, label: {
                        Text("addBaby.connect.button")
                            .authButtonTextStyle(bgColor: .gray)
                    })
                }
            }
            .padding(16)
            .navigationTitle("아기 추가")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddBabyView()
}
