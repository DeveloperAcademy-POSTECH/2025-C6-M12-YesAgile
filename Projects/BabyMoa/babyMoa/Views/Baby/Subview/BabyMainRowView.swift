//
//  BabyMainRowView.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import SwiftUI

struct BabyMainRowView: View {
    
    
    let title: String
    let buttonLabel: String
    let action: () -> Void // 버튼이 눌렸을 때 실행될 코드
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.font)
            
            // 3. 파라미터로 받은 'action' 사용
            Button(action: action) {
                HStack {
                    Text(buttonLabel)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            // .outlinelessButton는 사용자 정의 스타일로 보입니다.
            .buttonStyle(.outlinelessButton)
        }
    }
}

#Preview {
    BabyMainRowView(title: "양육자 코드", buttonLabel: "아기추가버튼") {
        // print
        print("버튼클릭했어요")
    }
}
