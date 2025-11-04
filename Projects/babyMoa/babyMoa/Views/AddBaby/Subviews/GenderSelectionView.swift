//
//  GenderSelectionView.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//


import SwiftUI

struct GenderSelectionView: View {
    @Binding var selectedGender: String
    let segments: [Segment]

    var body: some View {
        VStack(alignment: .leading) {
            Text("성별")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.font) // Assuming .font is a custom color

            HStack(spacing: 10) {
                ForEach(segments) { segment in
                    Button(segment.title) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedGender = segment.tag
                        }
                    }
                    .buttonStyle(selectedGender == segment.tag ? .outlineButton : .outlineSecondButton)
                }
            }
        }
    }
}
