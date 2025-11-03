//
//  ButtonStyles.swift
//  babyMoa
//
//  Created by Baba on 10/31/25.
//

import SwiftUI

struct GenderSelectButtonStyle: ButtonStyle {
    var selectedGender: String
    var value: String
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(selectedGender == value ? .white : color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(selectedGender == value ? color : Color.clear)
            .contentShape(Rectangle())
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: 1.5)
            )
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}


struct DateSelectButtonStyle: ButtonStyle{
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color("Gray-80")) // 참고: 이 색상은 Assets에 정의되어 있어야 합니다.
            .cornerRadius(8)
    }
    
}


struct DefaultButtonStyle: ButtonStyle {
    
    var fontColor: Color = .white
    var backgroundColor: Color = .blue // 'backgoundColor' 오타 수정

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(fontColor)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(backgroundColor) // 'backgoundColor' 오타 수정
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}


// --- 👇 #Preview 매크로로 수정한 미리보기 ---

#Preview {
    VStack(spacing: 30) {
        
        Text("GenderSelectButtonStyle")
            .font(.headline)
        
        // GenderSelectButtonStyle (선택됨 / 선택 안됨)
        HStack(spacing: 10) {
            Button("남아") { }
                .buttonStyle(GenderSelectButtonStyle(
                    selectedGender: "남아", // 현재 선택된 값
                    value: "남아",          // 이 버튼의 값
                    color: .brand50
                ))
            
            Button("여아") { }
                .buttonStyle(GenderSelectButtonStyle(
                    selectedGender: "남아", // 현재 선택된 값
                    value: "여아",          // 이 버튼의 값
                    color: .pink
                ))
        }
        
        Text("DateSelectButtonStyle")
            .font(.headline)

        // DateSelectButtonStyle
        // ⚠️ "Gray-80" 색상이 Assets에 없으면 이 프리뷰는 오류가 발생할 수 있습니다.
        Button("2025년 10월 31일") { }
            .buttonStyle(DateSelectButtonStyle())
            .foregroundColor(.black) // 버튼 스타일이 텍스트 색을 지정하지 않으므로 추가
        
        
        Text("DefaultButtonStyle")
            .font(.headline)

        // DefaultButtonStyle
        Button("저장하기") { }
            .buttonStyle(DefaultButtonStyle(
                fontColor: .white,
                backgroundColor: .brand70
            ))
    }
    .padding()
}
