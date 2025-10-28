//
//  AllMilestonesButton.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  전체 마일스톤 확인 버튼 컴포넌트
//

import SwiftUI

struct AllMilestonesButton: View {
    let onTap: () -> Void
    let title: String

    init(title: String = "성장 마일스톤 확인하기", onTap: @escaping () -> Void) {
        self.title = title
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [
                            Color("BrandPrimary"), Color("BrandSecondary"),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(
                    color: Color("BrandPrimary").opacity(0.3),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        }
        .padding(.top, 8)
    }
}

#Preview {
    AllMilestonesButton(onTap: {})
        .padding()
}
