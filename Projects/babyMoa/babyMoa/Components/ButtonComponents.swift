//
//  ButtonComponents.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI

struct AuthButtonTextStyle: ViewModifier {
    
    var bgColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


extension View{
    func authButtonTextStyle(bgColor: Color = .blue) -> some View {
        modifier(AuthButtonTextStyle(bgColor: bgColor))
    }
}
