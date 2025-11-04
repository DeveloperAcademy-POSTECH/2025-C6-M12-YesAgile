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
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea().onTapGesture {
                showRelationshipPicker = false
            }
            VStack {
                VStack(spacing: 0) {
                    Picker("관계", selection: $relationship) {
                        ForEach(RelationshipType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Divider()
                    
                    HStack(spacing: 0) {
                        Button("취소") {
                            showRelationshipPicker = false
                        }
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(Color(.systemBackground))
                        
                        Divider().frame(height: 44)
                        
                        Button("완료") {
                            showRelationshipPicker = false
                        }
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(Color(.systemBackground))
                    }
                }
                .background(.white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 40)

        }
    }
}

#Preview {
    RelationshipPickerModal(relationship: .constant(.mom),
                            showRelationshipPicker: .constant(true))
}
