//
//  RelationshipPickerModal.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import SwiftUI

struct RelationshipPickerModal: View {
    @Binding var relationship: RelationshipType
    @Binding var showRelationshipPicker: Bool

    var body: some View {
        VStack {
            Picker("관계", selection: $relationship) {
                ForEach(RelationshipType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.wheel)
            Button("완료") { showRelationshipPicker = false }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}
