//
//  GenderBadge.swift
//  babyMoa
//
//  Created by pherd on 10/29/25.
//

import SwiftUI

struct GenderBadge: View {
    let gender: Baby.Gender
    
    private var genderText: String {
        switch gender {
        case .male: return "남아"
        case .female: return "여아"
        case .notSpecified: return "성별 미정"
        @unknown default: return "성별 미정"
        }
    }
    
    private var genderColor: Color {
        switch gender {
        case .male: return Color("Brand-50")
        case .female: return Color("MemoryPink")
        case .notSpecified: return Color.gray
        @unknown default: return Color.gray
        }
    }
    
    var body: some View {
        Text(genderText)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(genderColor)
            .cornerRadius(20)
    }
}

