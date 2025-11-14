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
        Button(title, action: action)
            .buttonStyle(isEnabled ? .defaultButton : .noneButton)
            .disabled(!isEnabled)
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
