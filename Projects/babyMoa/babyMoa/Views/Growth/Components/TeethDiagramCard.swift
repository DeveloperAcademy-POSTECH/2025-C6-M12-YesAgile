//
//  TeethDiagramCard.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  치아 다이어그램 카드 컴포넌트
//  핑크 그라디언트 배경 + 위아래 치아 행

import SwiftUI

/// 치아 다이어그램 전체 (위아래 10개씩)
struct TeethDiagramCard: View {
    let upperTeeth: [ToothPosition]
    let lowerTeeth: [ToothPosition]
    let isErupted: (ToothPosition) -> Bool
    let selectedPosition: ToothPosition?
    let onToothTap: (ToothPosition) -> Void

    var body: some View {
        VStack(spacing: 8) {
            // 위쪽 치아 (1~10)
            TeethRow(
                teeth: upperTeeth,
                isErupted: isErupted,
                selected: selectedPosition,
                onToothTap: onToothTap
            )

            // 아래쪽 치아 (11~20)
            TeethRow(
                teeth: lowerTeeth,
                isErupted: isErupted,
                selected: selectedPosition,
                onToothTap: onToothTap
            )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background(Color("MemoryLightPink"))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    TeethDiagramCard(
        upperTeeth: [
            .upperRight5, .upperRight4, .upperRight3, .upperRight2,
            .upperRight1,
            .upperLeft1, .upperLeft2, .upperLeft3, .upperLeft4, .upperLeft5,
        ],
        lowerTeeth: [
            .lowerRight5, .lowerRight4, .lowerRight3, .lowerRight2,
            .lowerRight1,
            .lowerLeft1, .lowerLeft2, .lowerLeft3, .lowerLeft4, .lowerLeft5,
        ],
        isErupted: { _ in false },
        selectedPosition: nil,
        onToothTap: { _ in }
    )
    .padding()
}
