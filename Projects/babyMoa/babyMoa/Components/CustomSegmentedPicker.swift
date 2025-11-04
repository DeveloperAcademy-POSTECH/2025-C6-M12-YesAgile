//
//  CustomSegmentedPicker.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import SwiftUI

struct Segment: Identifiable {
    var id: String { tag }
    let tag: String
    let title: String
}

struct CustomSegmentedPicker: View {
    
    @Binding var selectionValue: String
    let segments: [Segment]
    
    
    //  CustomeSegmentedPicker 색 설정
    
    var selectedColor: Color = .blue
    var backgroundColor: Color = .clear
    var textColor: Color = .white
    var selectedTextColor: Color = .black
    
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments) { segment in
                
                Button(segment.title) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectionValue = segment.tag
                    }
                }
                .buttonStyle(selectionValue == segment.tag ? .secondButton: .outlineButton)
                
                
                Button(action: {
                    // 버튼을 누르면 selection 값을 변경
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectionValue = segment.tag
                    }
                }) {
                    Text(segment.title)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                    // 3항 연산자로 선택 여부에 따라 색상 변경
                        .background(selectionValue == segment.tag ? selectedColor : Color.clear)
                        .foregroundColor(selectionValue == segment.tag ? selectedTextColor : textColor)
                }
            }
        }
        .background(backgroundColor) // 전체 배경색
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selection = "male"
        let segments = [
            Segment(tag: "male", title: "남아"),
            Segment(tag: "female", title: "여아"),
            Segment(tag: "unknown", title: "미정")
        ]

        var body: some View {
            CustomSegmentedPicker(selectionValue: $selection, segments: segments)
                .padding()
                .background(Color.gray.opacity(0.3))
        }
    }
    return PreviewWrapper()
}
