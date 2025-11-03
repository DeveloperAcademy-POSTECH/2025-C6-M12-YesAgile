//
//  GrowthRecordRow.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  공통 기록 행 컴포넌트 (키/몸무게 기록 리스트용)

import SwiftUI

/// 키/몸무게 기록 행 (통합 버전)
/// - 월령, 날짜, 증감, 값 표시
struct GrowthRecordRow: View {
    let ageText: String  // "13개월"
    let dateText: String  // "2025.10.22"
    let difference: Double?  // 증감 (+0.5 등)
    let value: Double  // 실제 값 (73.1)
    let unit: String  // 단위 ("cm", "kg")
    let onTap: (() -> Void)?  // 선택 시 액션 (상세 보기 등)

    init(
        ageText: String,
        dateText: String,
        difference: Double? = nil,
        value: Double,
        unit: String,
        onTap: (() -> Void)? = nil
    ) {
        self.ageText = ageText
        self.dateText = dateText
        self.difference = difference
        self.value = value
        self.unit = unit
        self.onTap = onTap
    }

    var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack(spacing: 16) {
                // 월령 표시 (왼쪽)
                VStack(alignment: .leading, spacing: 4) {
                    Text(ageText)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)

                    Text(dateText)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }

                Spacer()

                // 증감 표시 (오른쪽 중간)
                if let diff = difference {
                    Text(String(format: "%+.1f", diff))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(
                            diff > 0
                                ? Color("Brand-50")
                                : Color("Font").opacity(0.4)
                        )
                }

                // 값 (오른쪽)
                HStack(spacing: 4) {
                    Text(String(format: "%.1f", value))
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary)

                    Text(unit)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }

                // 화살표
                if onTap != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray.opacity(0.3))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 0) {
        GrowthRecordRow(
            ageText: "13개월",
            dateText: "2025.10.22",
            difference: 0.1,
            value: 73.1,
            unit: "cm"
        )

        Divider().padding(.leading, 20)

        GrowthRecordRow(
            ageText: "13개월",
            dateText: "2025.10.21",
            difference: nil,
            value: 73.0,
            unit: "cm"
        )
    }
}
