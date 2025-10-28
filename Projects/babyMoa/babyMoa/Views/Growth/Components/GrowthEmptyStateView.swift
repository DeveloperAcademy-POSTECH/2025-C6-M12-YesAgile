//
//  GrowthEmptyStateView.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  빈 상태 뷰 컴포넌트

import SwiftUI

/// 빈 상태 뷰 (기록 없을 때)
/// - 아이콘, 타이틀, 서브타이틀 커스터마이징 가능
struct GrowthEmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String

    init(
        icon: String = "sparkles",
        title: String = "아직 기록이 없어요",
        subtitle: String = "아래 버튼을 눌러 첫 기록을 추가해보세요"
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top, 80)

            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)

            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    GrowthEmptyStateView(icon: "ruler", title: "아직 기록이 없어요")
}
