//
//  ToothButton.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  개별 치아 버튼 컴포넌트

import SwiftUI

/// 개별 치아 버튼 (선택/미선택, 기록/미기록 상태 표시)
struct ToothButton: View {
    let position: ToothPosition
    let isRecorded: Bool
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // 치아 모양 (둥근 사각형)
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(isRecorded ? Color.white : Color.white.opacity(0.3))
                    .frame(width: 28, height: 42)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(
                                isRecorded
                                    ? Color.white : Color.white.opacity(0.5),
                                lineWidth: isRecorded ? 2 : 1
                            )
                    )
                    .overlay(
                        // 선택 시 브랜드 컬러 외곽선 2pt
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(
                                isSelected
                                    ? Color("Brand-50") : Color.clear,
                                lineWidth: 2
                            )
                            .frame(width: 32, height: 46)
                    )

                // 치아 번호 (1~20)
                Text(getToothNumber(position))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(
                        isRecorded
                            ? Color.pink.opacity(0.8) : .white.opacity(0.6)
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    /// 치아 위치를 1~20 번호로 변환
    /// 위: 1~10 (우5→우1, 좌1→좌5)
    /// 아래: 11~20 (우5→우1, 좌1→좌5)
    private func getToothNumber(_ position: ToothPosition) -> String {
        switch position {
        // 위 (1~10)
        case .upperRight5: return "1"
        case .upperRight4: return "2"
        case .upperRight3: return "3"
        case .upperRight2: return "4"
        case .upperRight1: return "5"
        case .upperLeft1: return "6"
        case .upperLeft2: return "7"
        case .upperLeft3: return "8"
        case .upperLeft4: return "9"
        case .upperLeft5: return "10"
        // 아래 (11~20)
        case .lowerRight5: return "11"
        case .lowerRight4: return "12"
        case .lowerRight3: return "13"
        case .lowerRight2: return "14"
        case .lowerRight1: return "15"
        case .lowerLeft1: return "16"
        case .lowerLeft2: return "17"
        case .lowerLeft3: return "18"
        case .lowerLeft4: return "19"
        case .lowerLeft5: return "20"
        default: return ""
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        ToothButton(
            position: .upperRight1,
            isRecorded: false,
            isSelected: false,
            onTap: {}
        )

        ToothButton(
            position: .upperRight2,
            isRecorded: true,
            isSelected: false,
            onTap: {}
        )

        ToothButton(
            position: .upperRight3,
            isRecorded: true,
            isSelected: true,
            onTap: {}
        )
    }
    .padding()
    .background(Color.pink.opacity(0.5))
}
