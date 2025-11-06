//
//  AddBabyView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

// 이 뷰는 단순이 이동하는 것만 해당되는 뷰입니다 

import SwiftUI

struct AddBabyView: View {
    
    @StateObject private var viewModel: AddBabyViewModel
    
    init(coordinator: BabyMoaCoordinator) {
        self._viewModel = StateObject(wrappedValue: AddBabyViewModel(coordinator: coordinator))
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            // 새로운 아기 추가하기
            VStack {
                Text("addBaby.new.title")
                    .titleTextStyle()
                
                Text("addBaby.new.description")
                    .subTitleTextStyle()
                
                
                Button("addBaby.new.button", action: {
                        // 어디로 가야 하는가?
                
                })
                .buttonStyle(.defaultButton)
            }
            
            // 초대코드 입력하기
            VStack {
                Text("addBaby.connect.title")
                    .titleTextStyle()
                
                Text("addBaby.connect.description")
                    .subTitleTextStyle()
                
                Button("addBaby.new.button", action: {
                        // 어디로 가야 하는가?
                })
                .buttonStyle(.secondButton)
            }
            
            Spacer()
        }
        .ignoresSafeArea()
        .backgroundPadding(.horizontal)

    }
}

#Preview {
    AddBabyView(coordinator: BabyMoaCoordinator())
}
