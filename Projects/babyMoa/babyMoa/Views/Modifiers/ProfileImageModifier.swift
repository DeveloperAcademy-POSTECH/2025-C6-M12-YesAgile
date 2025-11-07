//
//  ProfileImageModifier.swift
//  BabyMoa
//
//  Created by Baba on 11/7/25.
//

import Foundation
import SwiftUI

extension Image {
    func profileImageStyle() -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .background(Color.orange90)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.brand40.opacity(0.2), lineWidth: 4))
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
}
