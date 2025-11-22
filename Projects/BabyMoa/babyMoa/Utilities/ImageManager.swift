//
//  ImageManager.swift
//  babyMoa
//
//  Created by 한건희 on 11/3/25.
//

import Foundation
import UIKit

final class ImageManager {
    public static let shared = ImageManager()
    
    private init() { }
    
    /// UIImage를 Base64 문자열로 인코딩
    func encodeToBase64(_ image: UIImage, compressionQuality: CGFloat = 0.5) -> String? {
        // UIImage를 JPEG 형식으로 Data 변환
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            print("Failed to convert UIImage to Data")
            return nil
        }
        // Base64 인코딩
        return imageData.base64EncodedString()
    }
    
    /// URL에서 이미지를 다운로드하여 UIImage로 반환 (캐싱 적용)
    func downloadImage(from urlString: String) async -> UIImage? {
        // 1. 캐시에서 이미지 확인
        if let cachedImage = ImageCacheManager.shared.getImage(for: urlString) {
            return cachedImage
        }
        
        print("🟡 [Cache Miss] No image in cache. Downloading from server for: \(urlString)")

        // 유효한 URL인지 확인
        guard let url = URL(string: urlString) else {
            print("🔴 [Download Error] Invalid URL: \(urlString)")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                print("🔴 [Download Error] Failed to create image from data for: \(urlString)")
                return nil
            }
            
            // 2. 다운로드 성공 시 캐시에 저장
            print("📥 [Download Success] Image downloaded. Saving to cache for: \(urlString)")
            ImageCacheManager.shared.setImage(image, imageData: data, for: urlString)
            return image
        } catch {
            print("🔴 [Download Error] Failed to download image from \(urlString): \(error)")
            return nil
        }
    }
    /// - Note: 배터리 절약 및 메모리 최적화를 위해 1024x1024로 제한
    func resizeImage(_ image: UIImage, maxSize: CGFloat = 1024) -> UIImage {
        let originalSize = image.size
        
        // 이미 작으면 원본 반환
        if originalSize.width <= maxSize && originalSize.height <= maxSize {
            return image
        }
        
        // 비율 유지하면서 리사이즈
        let aspectRatio = originalSize.width / originalSize.height
        var newSize: CGSize
        
        if originalSize.width > originalSize.height {
            newSize = CGSize(width: maxSize, height: maxSize / aspectRatio)
        } else {
            newSize = CGSize(width: maxSize * aspectRatio, height: maxSize)
        }
        
        // 리사이즈 수행
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
}
