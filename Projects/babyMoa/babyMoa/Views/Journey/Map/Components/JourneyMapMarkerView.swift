//
//  JourneyMapMarkerView.swift
//  babyMoa
//
//  Created by pherd on 11/21/25.
//  Refactored on 11/22/25
//

import SwiftUI

/// 사진 마커 뷰 - 지도 위 커스텀 마커
struct JourneyMapMarkerView: View {
    let imageUrl: String?
    let fallbackImage: UIImage?
    
    init(imageUrl: String? = nil, fallbackImage: UIImage? = nil) {
        self.imageUrl = imageUrl
        self.fallbackImage = fallbackImage
    }
    
    var body: some View {
        Group {
            if let localImage = fallbackImage {
                Image(uiImage: localImage)
                    .resizable()
                    .scaledToFill()
            } else {
                CachedAsyncImage(urlString: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.white
                            ProgressView()
                                .scaleEffect(0.5)
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .frame(width: 36, height: 36)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 2)
        )
        .shadow(radius: 3)
    }
}

#Preview {
    JourneyMapMarkerView(fallbackImage: UIImage(systemName: "photo"))
}

