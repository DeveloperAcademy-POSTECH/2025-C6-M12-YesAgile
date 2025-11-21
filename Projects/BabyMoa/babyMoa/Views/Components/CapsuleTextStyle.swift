//
//  CapsuleTextStyle.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import Foundation
import SwiftUI


//MARK: -  Title Text를 표준화하여 관리한다.
struct TitleTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 26, weight: .medium))
    }
}


struct SubTitleTextStyle: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 14, weight: .medium))
    }
}

struct LabelTextStyle: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .medium))
    }
}

//MARK: - Extension을 이용해서 관리한다. modifier 을 사용하지 않고 사용한다.

extension View {
    func titleTextStyle() -> some View {
        modifier(TitleTextStyle())
    }
    
    func subTitleTextStyle() -> some View {
        modifier(SubTitleTextStyle())
    }
    
    func labelTextStyle() -> some View {
        modifier(LabelTextStyle())
    }
}

