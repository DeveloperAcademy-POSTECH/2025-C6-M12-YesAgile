//
//  AddCreateBabyView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI

struct AddBabyCreate: View {
    @StateObject private var viewModel: AddBabyViewModel

    init(coordinator: BabyMoaCoordinator) {
        _viewModel = StateObject(wrappedValue: AddBabyViewModel(coordinator: coordinator))
    }

    var body: some View {
        VStack(spacing: 20) {
            
            CustomNavigationBar(title: "설정", leading: {
                Button(action: {
                    viewModel.coordinator.pop()
                }) {
                    Image(systemName: "chevron.left")
                }
            })
            
            ScrollView {
                Text("addBabyNew.question.title")
                    .titleTextStyle()
                    .padding(.bottom, 60)

                
                // "예" 버튼 → AddBabyNewYesView
                Button("addBabyNew.question.yesButton") {
                    viewModel.coordinator.push(path: .addBabyStatus(baby: nil, isBorn: true))
                }
                .buttonStyle(.defaultButton)
                
                Button("addBabyNew.question.noButton") {
                    viewModel.coordinator.push(path: .addBabyStatus(baby: nil, isBorn: false))
                }
                .buttonStyle(.secondButton)

                
                
                Spacer()
            }
            .scrollIndicators(.hidden)
            
            
        }
        .ignoresSafeArea()
        .backgroundPadding(.horizontal)
    }
}

#Preview {
    AddBabyCreate(coordinator: BabyMoaCoordinator())
}
