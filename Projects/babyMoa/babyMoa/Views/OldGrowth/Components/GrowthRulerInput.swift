//
//  GrowthRulerInput.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  눈금자 기반 입력 컴포넌트

import SwiftUI

/// 드래그 가능한 눈금자 입력 (키/몸무게용)
/// - 값 표시 박스 + 눈금자 UI 통합
struct GrowthRulerInput: View {
    @Binding var value: Double
    let maxValue: Double  // 최대값 (키: 200cm, 몸무게: 20kg)
    let unit: String  // 단위 ("cm", "kg")
    let label: String  // 라벨 ("키", "몸무게")

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 라벨
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)

            VStack(spacing: 0) {
                // 값 표시 박스
                Text(String(format: "%.1f\(unit)", value))
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange, lineWidth: 1.5)
                    )

                // 눈금자 (드래그 가능)
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // 눈금선들
                        HStack(spacing: 0) {
                            ForEach(0..<21) { index in
                                VStack(spacing: 0) {
                                    Spacer()
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(
                                            width: 1,
                                            height: index % 2 == 0 ? 16 : 10
                                        )
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }

                        // 현재 값 위치 강조선
                        VStack(spacing: 0) {
                            Spacer()
                            Rectangle()
                                .fill(Color.orange)
                                .frame(width: 2, height: 20)
                        }
                        .frame(width: 2)
                        .offset(
                            x: geometry.size.width * (value / maxValue) - 1
                        )
                    }
                }
                .frame(height: 30)
                .padding(.top, 8)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { dragValue in
                            let totalWidth = UIScreen.main.bounds.width - 40
                            let ratio = max(
                                0,
                                min(1, dragValue.location.x / totalWidth)
                            )
                            value = ratio * maxValue
                        }
                )
            }
        }
    }
}

#Preview {
    VStack {
        GrowthRulerInput(
            value: .constant(50.0),
            maxValue: 200.0,
            unit: "cm",
            label: "키"
        )
        .padding()

        GrowthRulerInput(
            value: .constant(10.0),
            maxValue: 20.0,
            unit: "kg",
            label: "몸무게"
        )
        .padding()
    }
}
