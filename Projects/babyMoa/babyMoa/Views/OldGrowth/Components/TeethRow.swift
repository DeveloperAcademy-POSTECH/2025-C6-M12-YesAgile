//
//  TeethRow.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  치아 행 컴포넌트 (위 또는 아래 10개)

import SwiftUI

/// 치아 행 (위 또는 아래 10개)
struct TeethRow: View {
    let teeth: [ToothPosition]
    let isErupted: (ToothPosition) -> Bool
    let selected: ToothPosition?
    let onToothTap: (ToothPosition) -> Void

    var body: some View {
        HStack(spacing: 4) {
            ForEach(teeth, id: \.self) { position in
                ToothButton(
                    position: position,
                    isRecorded: isErupted(position),
                    isSelected: selected == position,
                    onTap: {
                        onToothTap(position)
                    }
                )
            }
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    TeethRow(
        teeth: [
            .upperRight5, .upperRight4, .upperRight3, .upperRight2,
            .upperRight1,
            .upperLeft1, .upperLeft2, .upperLeft3, .upperLeft4, .upperLeft5,
        ],
        isErupted: { _ in false },
        selected: nil,
        onToothTap: { _ in }
    )
    .padding()
    .background(Color.pink.opacity(0.3))
}
