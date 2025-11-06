//
//  AddCreateBabyView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI

struct AddBabyCreate: View {
    var body: some View {
        VStack(spacing: 20) {
            
            CustomNavigationBar(title: "설정", leading: {
                Button(action: {
                    
                    // 어디로 이동을 해야 되는가?
                    
                }) {
                    Image(systemName: "chevron.left")
                }
            })
            
            Text("addBabyNew.question.title")
                .titleTextStyle()
                .padding(.bottom, 60)

            
            // "예" 버튼 → AddBabyNewYesView
            Button("addBabyNew.question.yesButton") {
                // Yes, Button
            }
            .buttonStyle(.defaultButton)
            
            Button("addBabyNew.question.noButton") {
                // No, Button
            }
            .buttonStyle(.secondButton)

            
            
            Spacer()
        }
        .ignoresSafeArea()
        .backgroundPadding(.horizontal)
    }
}

#Preview {
    AddBabyCreate()
}
