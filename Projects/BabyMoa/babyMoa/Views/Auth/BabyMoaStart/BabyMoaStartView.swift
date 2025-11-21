//
//  BabyMoaStartView.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

struct BabyMoaStartView: View {
    
    @State var viewModel: BabyMoaStartViewModel
    @State private var isShowSheet: Bool = false // Assuming this is the user's state variable
    
    init(coordinator: BabyMoaCoordinator) {
        viewModel = BabyMoaStartViewModel(coordinator: coordinator)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image("authImg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.width - 30)
                .aspectRatio(contentMode: .fit)
            
            
            Text("아기의 성장발달마다 기록하고 추억해요")
                .font(.system(size: 30, weight: .bold))
                .padding(.bottom, 44)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                
            Spacer()
            
            Button("BabyMoa 시작하기", action: {
                isShowSheet = true // Show the sheet
                // viewModel.coordinator.push(path: .login) 
            })
            .buttonStyle(.defaultButton)
            .padding(.bottom, 44)
            
        }
        .backgroundPadding(.horizontal)
        .sheet(isPresented: $isShowSheet) {
            SignUpView(coordinator: viewModel.coordinator)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    @Previewable @StateObject var coordinator: BabyMoaCoordinator = BabyMoaCoordinator()
    BabyMoaStartView(coordinator: coordinator)
}
