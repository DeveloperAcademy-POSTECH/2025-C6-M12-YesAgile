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
        VStack(alignment: .leading, spacing: 10) {
            Text("성별")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.font)

            HStack(spacing: 10) {
                ForEach(segments.filter { $0.tag != "none" }) { segment in
                    Button(segment.title) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedGender = segment.tag
                        }
                    }
                    .buttonStyle(selectedGender == segment.tag ? .outlineButton : .outlineSecondButton)
                }
            }

            Button(action: {
                // When tapped, set the gender to "none"
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedGender = "none"
                }
            }) {
                HStack(spacing: 8) {
                    // Custom Checkbox
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 20, height: 20)

                        if selectedGender == "none" {
                            RoundedRectangle(cornerRadius: 4)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.brandMain)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    
                    Text("아직 성별을 몰라요")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.font)
                    Spacer()
                }
            }
            .padding(.top, 10)
        }
    }
}

#Preview {
    @Previewable @State var selectedGender: String = "male" // Default selected gender for preview
    let mockSegments = [
        Segment(tag: "male", title: "남아", ),
        Segment(tag: "female", title: "여아"),
        Segment(tag: "none", title: "선택 안 함")
    ]
    
    GenderSelectionView(selectedGender: $selectedGender, segments: mockSegments)
}
