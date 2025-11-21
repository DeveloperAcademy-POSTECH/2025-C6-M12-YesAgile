//
//  GrowthLabeledField.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  라벨 + 입력 필드 컴포넌트'

import SwiftUI

/// 라벨 + 입력 필드 (공통 스타일)
/// - 측정일, 메모 등에 재사용
struct GrowthLabeledField<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)

            content
        }
    }
}





#Preview {
    VStack(spacing: 24) {
        GrowthDateButton(date: Date()) {
            print("Date tapped")
        }

        GrowthMemoField(text: .constant(""))
    }
    .padding()
}
