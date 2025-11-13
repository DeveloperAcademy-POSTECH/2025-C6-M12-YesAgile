//
//  EmptyRecordView.swift
//  BabyMoa
//
//  Created by Baba on 11/13/25.
//

import SwiftUI

struct EmptyRecordView: View {
    let title: String
    let description: String
    let imageSystemName: String

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: imageSystemName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)


            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    EmptyRecordView(
        title: "아직 기록이 없어요.",
        description: "첫 기록을 추가하고 아이의 성장을 기록해보세요.",
        imageSystemName: "doc.badge.plus",
    )
}
