//
//  RelationshipSelectionView.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import SwiftUI

struct RelationshipSelectionView: View {
    @Binding var relationship: RelationshipType
    @Binding var showRelationshipPicker: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("아이와 나의 관계")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("Font").opacity(0.6))
            
            Button(action: { showRelationshipPicker = true }) {
                HStack {
                    Text(relationship.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("Font"))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("Font").opacity(0.4))
                }
            }
            .buttonStyle(DateSelectButtonStyle())

        }
    }
}


#Preview {
    RelationshipSelectionView(relationship: .constant(.mom), showRelationshipPicker: .constant(false))
}

