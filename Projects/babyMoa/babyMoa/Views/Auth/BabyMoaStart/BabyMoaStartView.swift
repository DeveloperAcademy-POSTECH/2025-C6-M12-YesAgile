//
//  BabyMoaStartView.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

struct BabyMoaStartView: View {
    
    @State var viewModel: BabyMoaStartViewModel
    
    init(coordinator: BabyMoaCoordinator) {
        viewModel = BabyMoaStartViewModel(coordinator: coordinator)
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("Baby Moa")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Text("아이의 성장발달 순간과 일상을 사진과 기록으로 담아, 성장과 추억을 함께 모아보세요")
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                Spacer()
                Button(action: {
                    viewModel.coordinator.push(path: .login)
                }) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 50)
                        .padding(.horizontal, 20)
                        .foregroundStyle(.black)
                        .overlay(
                            Text("BabyMoa 시작하기")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.white)
                        )
                }
                .buttonStyle(.plain)
            }
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height / 2
            )
            Spacer()
        }
    }
}

#Preview {
    @Previewable @StateObject var coordinator: BabyMoaCoordinator = BabyMoaCoordinator()
    BabyMoaStartView(coordinator: coordinator)
}
