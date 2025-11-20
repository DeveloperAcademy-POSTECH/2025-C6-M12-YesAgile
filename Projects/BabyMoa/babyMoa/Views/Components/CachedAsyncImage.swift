//
//  CachedAsyncImage.swift
//  babyMoa
//
//  Created by Baba on 11/20/25.
//
//  This view mimics SwiftUI's AsyncImage, but uses a custom ImageManager
//  to leverage a shared, persistent cache.
//

import SwiftUI

struct CachedAsyncImage<Content: View>: View {
    
    @State private var phase: AsyncImagePhase = .empty
    
    let urlString: String?
    let transaction: Transaction
    let content: (AsyncImagePhase) -> Content
    
    // Define the error type at the struct level, not inside the function.
    private struct ImageLoadError: Error {}
    
    init(
        urlString: String?,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.urlString = urlString
        self.transaction = transaction
        self.content = content
    }

    var body: some View {
        content(phase)
            .task(id: urlString, priority: .background) {
                await loadImage(urlString: urlString)
            }
    }
    
    private func loadImage(urlString: String?) async {
        guard let url = urlString, !url.isEmpty else {
            self.phase = .empty
            return
        }
        
        // Set phase to empty before starting.
        if !Task.isCancelled {
            withAnimation(transaction.animation) {
                self.phase = .empty
            }
        }
        
        // Use our custom image manager to fetch the image.
        // This will hit the memory/disk cache or download from the network.
        if let uiImage = await ImageManager.shared.downloadImage(from: url) {
            if !Task.isCancelled {
                let image = Image(uiImage: uiImage)
                withAnimation(transaction.animation) {
                    self.phase = .success(image)
                }
            }
        } else {
            if !Task.isCancelled {
                // Now we can create an instance of the error.
                withAnimation(transaction.animation) {
                    self.phase = .failure(ImageLoadError())
                }
            }
        }
    }
}

#Preview {
    // Example usage:
    let sampleUrl = "https://yesagile-s3-bucket.s3.amazonaws.com/avatars/2025/11/08/38d90084-0fcd-4f34-bc25-471dc2d2f704.jpg"
    
    return VStack {
        Text("CachedAsyncImage Preview")
            .font(.headline)
        
        CachedAsyncImage(urlString: sampleUrl) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 100, height: 100)
    }
}
