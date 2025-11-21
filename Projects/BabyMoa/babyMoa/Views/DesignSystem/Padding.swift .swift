//
//  Padding.swift .swift
//  babyMoa
//
//  Created by Baba on 10/30/25.
//

import Foundation
import SwiftUI

// 1. 패딩의 종류를 의미론적으로 정의
public enum BackgroundPadding {
    case horizontal
    case all
}

// 2. ViewModifier 정의
struct ViewPaddingModifier: ViewModifier {
    let type: BackgroundPadding

    var paddingValue: EdgeInsets {
        switch type {
        case .horizontal:
            // .top, .bottom = 12, .leading, .trailing = 16
            return EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        case .all:
            // .top, .bottom = 8, .leading, .trailing = 12
            return EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        }
    }

    func body(content: Content) -> some View {
        content
            .padding(paddingValue)
    }
}

// 3. View 확장 (사용 편의성)
public extension View {
    /// 버튼에 디자인 시스템 패딩을 적용합니다.
    func backgroundPadding(_ type: BackgroundPadding) -> some View {
        self.modifier(ViewPaddingModifier(type: type))
    }
}
