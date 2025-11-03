//
//  GrowthBottomButton.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  하단 고정 버튼 컴포넌트

import SwiftUI

/// 하단 고정 버튼 (주황색 CTA) -> 색은 나중에 수정
/// - 기록 추가, 저장 등에 재사용
struct GrowthBottomButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    init(title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    isEnabled ? Color("Brand-50") : Color.gray.opacity(0.3)
                )
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
}

#Preview {
    VStack {
        Spacer()
        GrowthBottomButton(title: "저장") {
            print("Saved")
        }
    }
}
