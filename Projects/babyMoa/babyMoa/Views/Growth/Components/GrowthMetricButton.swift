//
//  GrowthMetricButton.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  키/몸무게 등 측정 버튼 컴포넌트
//

import SwiftUI

struct GrowthMetricButton: View {
    let title: String
    let icon: String
    let latestValue: String?
    let latestDate: String?
    let color: Color
    let onTap: () -> Void
    let illustration: Image?

    init(
        title: String,
        icon: String,
        latestValue: String? = nil,
        latestDate: String? = nil,
        color: Color = .blue,
        onTap: @escaping () -> Void,
        illustration: Image? = nil
    ) {
        self.title = title
        self.icon = icon
        self.latestValue = latestValue
        self.latestDate = latestDate
        self.color = color
        self.onTap = onTap
        self.illustration = illustration
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // 배경: 라운드 + 그림자
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(color)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)

                // 좌측: 제목/값
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    if let value = latestValue {
                        Text(value)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .padding(14)

                // 우측: 일러스트 영역 (배경 없이 이미지만 표시)
                if let illustration = illustration {
                    illustration
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .bottomTrailing
                        )
                        .padding(.trailing, 8)
                        .padding(.bottom, title == "몸무게" ? -14 : -1)  // 몸무게만 더 아래로 왼쪽 몸무게 오른쪽은 기린
                }
            }
            .frame(height: 100)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HStack(spacing: 12) {
        GrowthMetricButton(
            title: "키",
            icon: "ruler",
            latestValue: "50.5cm",
            latestDate: "2025.10.26",
            color: Color("Orange-50"),
            onTap: {}
        )

        GrowthMetricButton(
            title: "몸무게",
            icon: "scalemass",
            color: Color("HeightSecondary"),
            onTap: {}
        )
    }
    .padding()
}
