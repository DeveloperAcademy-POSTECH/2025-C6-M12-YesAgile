//
//  GrowthLabeledField.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  라벨 + 입력 필드 컴포넌트

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

// MARK: - 날짜 버튼 (별도 View로 분리)

struct GrowthDateButton: View {
    let label: String
    let date: Date
    let onTap: () -> Void

    init(label: String = "측정일", date: Date, onTap: @escaping () -> Void) {
        self.label = label
        self.date = date
        self.onTap = onTap
    }

    var body: some View {
        GrowthLabeledField(label: label) {
            Button(action: onTap) {
                HStack {
                    Text(formattedDate)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(16)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange, lineWidth: 1.5)
                )
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd."
        return formatter.string(from: date)
    }
}

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
