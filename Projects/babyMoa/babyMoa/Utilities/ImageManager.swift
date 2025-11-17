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
    
    /// URL에서 이미지를 다운로드하여 UIImage로 반환
    func downloadImage(from urlString: String) async -> UIImage? {
        // 유효한 URL인지 확인
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return nil
        }
        
        do {
            let sessionResult = try await URLSession.shared.data(from: url)
            // sessionResult.0: data
            // sessionResult.1: URLResponse
            return UIImage(data: sessionResult.0)
        } catch(let e) {
            return nil
        }
    }
}
