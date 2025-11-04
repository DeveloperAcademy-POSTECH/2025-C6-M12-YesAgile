//
//  AddBabyView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

// 이 뷰는 단순이 이동하는 것만 해당되는 뷰입니다 

import SwiftUI

struct AddBabyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            // 새로운 아기 추가하기
            VStack {
                Text("addBaby.new.title")
                    .titleTextStyle()
                
                Text("addBaby.new.description")
                    .subTitleTextStyle()
                
                Button(action: {
                    // 이동하는 위치 : 어디파일로 가는것인가?
                    
                    
                }) {
                    Text("addBaby.new.button")
                        .authButtonTextStyle(bgColor: .brand50)
                }
            }
            
            // 초대코드 입력하기
            VStack {
                Text("addBaby.connect.title")
                    .titleTextStyle()
                
                Text("addBaby.connect.description")
                    .subTitleTextStyle()
                
                Button(action: {
                    // 이동하는 위치 : 어디파일로 가는것인가?

                }, label: {
                    Text("addBaby.connect.button")
                        .authButtonTextStyle(bgColor: .brand70)
                })
            }
            
            Spacer()
        }
        .ignoresSafeArea()
        .backgroundPadding(.horizontal)

    }
}

#Preview {
    AddBabyView()
}
