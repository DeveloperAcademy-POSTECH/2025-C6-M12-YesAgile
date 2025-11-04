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
    var body: some View {
        HStack(spacing: 10) {
            ForEach(segments) { segment in
                
                Button(segment.title) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectionValue = segment.tag
                    }
                }
                .buttonStyle(selectionValue == segment.tag ? .outlineButton: .outlineSecondButton)
            }
        }
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
        }
    }
    return PreviewWrapper()
}
