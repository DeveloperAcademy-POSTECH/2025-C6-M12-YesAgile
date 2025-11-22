//
//  JourneyMapMarkerView.swift
//  babyMoa
//
//  Created by pherd on 11/21/25.
//

import SwiftUI

/// 사진 마커 뷰 - 지도 위 커스텀 마커
struct JourneyMapMarkerView: View {
    let image: Image // Changed from UIImage
    
    var body: some View {
        image // Display the SwiftUI Image directly
            .resizable()
            .scaledToFill()
            .frame(width: 36, height: 36)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 3)
    }
}

