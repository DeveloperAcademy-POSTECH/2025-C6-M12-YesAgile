import SwiftUI

// MARK: - 메모 필드
struct GrowthMemoField: View {
    let label: String
    @Binding var text: String
    let placeholder: String

    init(
        label: String = "메모",
        text: Binding<String>,
        placeholder: String = "메모를 입력하세요"
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
    }

    var body: some View {
        GrowthLabeledField(label: label) {
            TextField(placeholder, text: $text, axis: .vertical)
                .padding(16)
                .frame(minHeight: 100, alignment: .top)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange, lineWidth: 1.5)
                )
        }
    }
}//
//  GrowthMemoField.swift
//  babyMoa
//
//  Created by 한건희 on 11/4/25.
//

