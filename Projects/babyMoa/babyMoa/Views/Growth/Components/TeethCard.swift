//
//  TeethCard.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  치아 카드 컴포넌트 (미니 프리뷰 포함)
//

import SwiftUI

struct TeethCard: View {
    let teethRecords: [TeethRecord]
    let onTap: () -> Void
    let illustration: Image?

    // 위쪽 10개 치아 (유치 기준)
    private let upperTeeth: [ToothPosition] = [
        .upperRight5, .upperRight4, .upperRight3, .upperRight2, .upperRight1,
        .upperLeft1, .upperLeft2, .upperLeft3, .upperLeft4, .upperLeft5,
    ]

    // 아래쪽 10개 치아 (유치 기준)
    private let lowerTeeth: [ToothPosition] = [
        .lowerRight5, .lowerRight4, .lowerRight3, .lowerRight2, .lowerRight1,
        .lowerLeft1, .lowerLeft2, .lowerLeft3, .lowerLeft4, .lowerLeft5,
    ]

    init(
        teethRecords: [TeethRecord],
        onTap: @escaping () -> Void,
        illustration: Image? = nil
    ) {
        self.teethRecords = teethRecords
        self.onTap = onTap
        self.illustration = illustration
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // 핑크색 배경 (라운드)
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        Color("MemoryLightPink")
                    )

                // 치아 2줄 + 가운데 라벨 (카드 중앙 정렬)
                VStack(spacing: 10) {
                    TeethMiniRow(
                        teeth: upperTeeth,
                        teethRecords: teethRecords,
                        isPink: true
                    )

                    Text("치아")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    TeethMiniRow(
                        teeth: lowerTeeth,
                        teethRecords: teethRecords,
                        isPink: true
                    )
                }
                .frame(maxWidth: .infinity)  // 전체 너비 차지
                // 일러스트를 치아 사이 정확한 중앙 라인에 오버레이
                .overlay(alignment: .center) {
                    if let illustration = illustration {
                        illustration
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .offset(x: 90)  // 오른쪽으로 이동
                    }
                }
            }
            .frame(height: 120)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 미니 치아 행 (프리뷰용)

struct TeethMiniRow: View {
    let teeth: [ToothPosition]
    let teethRecords: [TeethRecord]
    var isPink: Bool = false  // 핑크 배경용

    var body: some View {
        HStack(spacing: 4) {
            ForEach(teeth, id: \.self) { position in
                let record = teethRecords.first(where: {
                    $0.position == position
                })
                let hasErupted = record?.hasErupted ?? false

                // 치아 아이콘
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(hasErupted ? Color.white : Color.white.opacity(0.3))
                    .frame(width: 22, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(
                                hasErupted
                                    ? Color.white : Color.white.opacity(0.5),
                                lineWidth: hasErupted ? 2 : 1
                            )
                    )
            }
        }
    }
}

#Preview {
    TeethCard(
        teethRecords: [
            TeethRecord(
                babyId: "test",
                position: .upperRight1,
                hasErupted: true,
                date: Date()
            ),
            TeethRecord(
                babyId: "test",
                position: .lowerLeft1,
                hasErupted: true,
                date: Date()
            ),
        ],
        onTap: {}
    )
    .padding()
}
