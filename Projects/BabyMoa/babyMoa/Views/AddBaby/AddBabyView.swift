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
        ZStack{
            Color.background
            VStack(spacing: 20) {
                
                CustomNavigationBar(title: "아기추가", leading: {
                    Button(action: {
                        
                        viewModel.coordinator.pop()
                        
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.font)
                    }
                })
                
                
                // 새로운 아기 추가하기
                VStack {
                    Text("addBaby.new.title")
                        .titleTextStyle()
                    
                    Text("addBaby.new.description")
                        .subTitleTextStyle()
                    
                    // 나중에 함수로 만들어서 사용할까???
                    Button("addBaby.new.button", action: {
                        viewModel.coordinator.push(path: .addBabyCreate)
                    })
                    .buttonStyle(.defaultButton)
                }
                
                // 초대코드 입력하기
                VStack {
                    Text("addBaby.connect.title")
                        .titleTextStyle()
                    
                    Text("addBaby.connect.description")
                        .subTitleTextStyle()
                    
                    // 나중에 함수로 만들어서 사용할까???
                    Button("addBaby.connect.button", action: {
                        viewModel.coordinator.push(path: .addBabyInvitaion)
                    })
                    .buttonStyle(.secondButton)
                }
                
                Spacer()
            }
            .backgroundPadding(.horizontal)
        }
        .ignoresSafeArea()

    }
}

#Preview {
    AddBabyView(coordinator: BabyMoaCoordinator())
}
