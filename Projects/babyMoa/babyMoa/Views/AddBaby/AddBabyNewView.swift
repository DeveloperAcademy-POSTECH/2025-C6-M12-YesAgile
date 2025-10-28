//
//  AddCreateBabyView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI

struct AddCreateBabyView: View {
    var body: some View {
        VStack {
            Text("addBabyNew.question.title")
                .titleTextStyle()
            
            // "예" 버튼 → AddBabyNewYesView
            NavigationLink(destination: AddBabyNewYes()) {
                Text("addBabyNew.question.yesButton")
                    .authButtonTextStyle(bgColor: .gray)
            }
            .padding(.top, 24)
            
            // "아니오" 버튼 → AddBabyNewNoView
            NavigationLink(destination: AddBabyNewNoView()) {
                Text("addBabyNew.question.noButton")
                    .authButtonTextStyle(bgColor: .gray)
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .padding(16)
    }
}

#Preview {
    AddCreateBabyView()
}
