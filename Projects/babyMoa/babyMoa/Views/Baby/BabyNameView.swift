//
//  BabyNameView.swift
//  babyMoa
//
//  Created by pherd on 10/29/25.
//

import SwiftUI

struct BabyNameView: View {
    let name: String?
    let nickname: String?
    
    var body: some View {
        Group {
            if let name = name, !name.isEmpty, let nickname = nickname, !nickname.isEmpty {
                // 케이스 1: 이름 + 태명 모두 있음
                HStack(spacing: 6) {
                    Text(name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("Font"))
                    
                    Text("| \(nickname)")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color("Font").opacity(0.6))
                }
            } else if let name = name, !name.isEmpty {
                // 케이스 2: 이름만 있음
                Text(name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color("Font"))
            } else if let nickname = nickname, !nickname.isEmpty {
                // 케이스 3: 태명만 있음
                Text(nickname)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color("Font"))
            } else {
                // 케이스 4: 둘 다 없음 (기본값)
                Text("아기 이름")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color("Font").opacity(0.4))
            }
        }
    }
}

