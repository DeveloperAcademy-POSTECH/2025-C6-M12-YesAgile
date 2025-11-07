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
