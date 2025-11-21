//
//  PhotoMarkerView.swift
//  babyMoa
//
//  Created by pherd on 11/21/25.
//

import SwiftUI

/// 사진 마커 뷰 - 지도 위 커스텀 마커
struct PhotoMarkerView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
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

