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
            
            HStack(spacing: 8){
                
                Button(action: {
                    
                }, label: {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.gray, lineWidth: 1)
                        .frame(width: 20, height: 20)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.brandMain)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(.white)
                                )
                        }
                })
                Text("아직 성별을 몰라요")
                    .font(.system(size: 14, weight: .regular))
                Spacer()
            }
            .padding(.top, 10)
        }
    }
}

#Preview {
    @Previewable @State var selectedGender: String = "male"
    let mockSegments = [
        Segment(tag: "male", title: "남아"),
        Segment(tag: "female", title: "여아"),
        Segment(tag: "none", title: "선택 안 함")
    ]
    
    GenderSelectionView(selectedGender: $selectedGender, segments: mockSegments)
}
