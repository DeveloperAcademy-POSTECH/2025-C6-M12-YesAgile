//
//  CachedAsyncImage.swift
//  babyMoa
//
//  Created by Baba on 11/20/25.
//
//  이 뷰는 SwiftUI의 AsyncImage와 유사하게 동작하지만,
//  공유된 영구 캐시(Memory/Disk)를 활용하기 위해 커스텀 ImageManager를 사용합니다.
//

import SwiftUI

struct CachedAsyncImage<Content: View>: View {
    
    @State private var phase: AsyncImagePhase = .empty
    
    let urlString: String?
    let transaction: Transaction
    let content: (AsyncImagePhase) -> Content
    
    // 함수 내부가 아닌 구조체 레벨에서 에러 타입을 정의합니다.
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
        
        // 시작하기 전에 단계를 empty로 설정합니다.
        if !Task.isCancelled {
            withAnimation(transaction.animation) {
                self.phase = .empty
            }
        }
        
        // 커스텀 이미지 매니저를 사용하여 이미지를 가져옵니다.
        // 이 과정에서 메모리/디스크 캐시를 확인하거나 네트워크에서 다운로드합니다.
        if let uiImage = await ImageManager.shared.downloadImage(from: url) {
            if !Task.isCancelled {
                let image = Image(uiImage: uiImage)
                withAnimation(transaction.animation) {
                    self.phase = .success(image)
                }
            }
        } else {
            if !Task.isCancelled {
                // 실패 시 에러 인스턴스를 생성하여 단계를 업데이트합니다.
                withAnimation(transaction.animation) {
                    self.phase = .failure(ImageLoadError())
                }
            }
        }
    }
}

#Preview {
    // 사용 예시:
    let sampleUrl = "https://yesagile-s3-bucket.s3.amazonaws.com/avatars/2025/11/08/38d90084-0fcd-4f34-bc25-471dc2d2f704.jpg"
    
    return VStack {
        Text("CachedAsyncImage 미리보기")
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
