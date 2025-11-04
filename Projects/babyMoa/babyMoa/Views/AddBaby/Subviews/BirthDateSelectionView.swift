//
//  BirthDateSelectionView.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import SwiftUI

struct BirthDateSelectionView: View {
    let label: String
    @Binding var showDatePicker: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("생년월일")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("Font").opacity(0.6))

            Button(action: { showDatePicker = true }) {
                HStack {
                    Text(label)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("Font"))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("Font").opacity(0.4))
                }
            }
            .buttonStyle(DateSelectButtonStyle())
        }
    }
}



#Preview {
    BirthDateSelectionView(
        label: "2025년 11월 04일", // 예시 날짜 텍스트 추가
        showDatePicker: .constant(false) // 기본 상태는 모달이 닫힌 상태이므로 false로 설정
    )
    .padding() // 미리보기에 여백을 주어 더 보기 좋게 만듭니다.
}
