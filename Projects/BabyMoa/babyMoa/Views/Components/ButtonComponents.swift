//
//  ButtonComponents.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI

struct AuthButtonTextStyle: ViewModifier {
    
    var fontSize: CGFloat = 14
    var bgColor: Color = .blue
    var fontColor: Color = .white
    var borderColor: Color = .clear
    
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(fontColor)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1)
            }
    }
}


extension View{
    func authButtonTextStyle(bgColor: Color = .blue) -> some View {
        modifier(AuthButtonTextStyle(bgColor: bgColor))
    }
}

extension View {
    /// 버튼 스타일을 유연하게 적용하는 함수입니다.
    /// 기본적으로 브랜드 색상을 사용한 아웃라인 스타일이 적용됩니다.
    func inviteTextStyle(
        fontSize: CGFloat = 24,
        bgColor: Color = .clear,
        fontColor: Color = .brand50,
        borderColor: Color = Color("BrandMain")
    ) -> some View {
        modifier(AuthButtonTextStyle(
            fontSize: fontSize,
            bgColor: bgColor,
            fontColor: fontColor,
            borderColor: borderColor
        ))
    }
}


// 이 뷰는 ViewModifier들을 테스트하기 위한 미리보기 전용 뷰입니다.
struct TextStylePreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Title Text (26, Medium)")
                .titleTextStyle()
                .background(Color.yellow.opacity(0.3)) // 👈 .padding() 영역 확인용
            
            Text("Subtitle Text (14, Medium)")
                .subTitleTextStyle()
                .background(Color.blue.opacity(0.3)) // 👈 .padding() 영역 확인용

            Text("Label Text (14, Medium)")
                .labelTextStyle()
                .background(Color.green.opacity(0.3)) // 👈 패딩이 없는 것 확인용
            
            Divider()
                .padding(.vertical, 10)
            
            // --- 실제 사용 예시 ---
            VStack(alignment: .leading, spacing: 8) {
                Text("오늘의 할 일")
                    .titleTextStyle()
                
                Text("아래 목록을 확인하고 완료하세요.")
                    .subTitleTextStyle()
                
                HStack {
                    Text("항목 1:")
                        .labelTextStyle() // 라벨 스타일 적용
                    Text("SwiftUI 공부하기")
                }
                .padding(.horizontal) // HStack에 직접 패딩 (Label 자체에는 패딩이 없으므로)
            }
        }
        .padding() // VStack 전체에 여백을 주어 보기 좋게 함
    }
}


// MARK: - Preview Macro

#Preview {
    TextStylePreview()
}
