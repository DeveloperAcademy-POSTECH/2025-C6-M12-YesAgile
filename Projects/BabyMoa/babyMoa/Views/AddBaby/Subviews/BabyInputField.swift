//
//  BabyInputField.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//


import SwiftUI

struct BabyInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var focus: FocusState<AddBabyStatusView.FocusField?>.Binding
    var field: AddBabyStatusView.FocusField

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.font)
            TextField(placeholder, text: $text)
                .textFieldStyle(.basicForm)
                .focused(focus, equals: field)
        }
    }
}
