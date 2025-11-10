//
//  JourneyGridView.swift
//  BabyMoa
//
//  Created by pherd on 11/8/25.
//

import SwiftUI

struct JourneyGridView: View {
    // 3열 그리드
    private let columns = [
        GridItem(.flexible(), spacing: 26),
        GridItem(.flexible(), spacing: 26),
        GridItem(.flexible(), spacing: 26)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    // 예시: 6개 아이템
                    ForEach(0..<6, id: \.self) { index in
                        CirclePhotoItem()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("여정 리스트")
        .font(.system(size: 16, weight: .bold))
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background)
    }
}

// MARK: - 원형 사진 아이템


struct CirclePhotoItem: View {
    var body: some View {
        Button(action: {
            // 클릭 액션
        }) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        JourneyGridView()
    }
}
