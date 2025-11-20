//
//  ToothButton.swift
//  babyMoa
//
//  Created by 한건희 on 11/3/25.
//

import SwiftUI

struct TeethButton: View {
    var toothTapAction: () -> Void
    
    var body: some View {
        Button(action: {
            toothTapAction()
        }) {
            RoundedRectangle(cornerRadius: 16)
//                .overlay(
//                    
//                )
        }
    }
}
