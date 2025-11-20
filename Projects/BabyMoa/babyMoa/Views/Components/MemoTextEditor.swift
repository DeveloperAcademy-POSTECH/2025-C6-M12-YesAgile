//
//  MemoTextEditor.swift
//  babyMoa
//
//  Created by Baba on 11/15/25.
//

import SwiftUI

struct MemoTextEditor: View {
    @Binding var memo: String
    let limit: Int
    @FocusState.Binding var isFocused: Bool
    var placeholder: String = "아이와 함께한 추억을 입력해주세요."

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("메모")
                .font(.system(size: 15, weight: .regular))

            ZStack(alignment: .topLeading) {

                // ⭐️ Placeholder
                if memo.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray70)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }

                // ✏️ TextEditor
                TextEditor(text: $memo)
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .frame(height: 150)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.brandLight, lineWidth: 1) // 안쪽으로만 그려짐
                    )
            }

            HStack {
                Spacer()
                Text("\(memo.count)/\(limit)자")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {

    struct MemoTextEditorPreview: View {
        @State private var memo: String = ""
        @FocusState private var isFocused: Bool

        var body: some View {
            MemoTextEditor(
                memo: $memo,
                limit: 300,
                isFocused: $isFocused,
                placeholder: "여기에 메모를 적어주세요!"   
            )
            .padding()
        }
    }

    return MemoTextEditorPreview()
}
