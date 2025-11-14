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

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("메모")
                .font(.system(size: 15, weight: .regular))

            TextEditor(text: $memo)
                .focused($isFocused)
                .scrollContentBackground(.hidden)
                .padding()
                .background(Color.clear)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.font)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.brandLight, lineWidth: 1)
                )
                .onChange(of: memo) {_, newValue in
                    if newValue.count > limit {
                        memo = String(newValue.prefix(limit))
                    }
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
                isFocused: $isFocused
            )
            .padding()
        }
    }
    
   return MemoTextEditorPreview()
}


