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
    
    func convertToUIImage(imageNameOrUrl: String) -> UIImage? {
        // 1. 로컬 이미지 먼저 시도
        if let localImage = UIImage(named: imageNameOrUrl) {
            return localImage
        }
        
        // 2. URL 접근 시도
        guard let url = URL(string: imageNameOrUrl) else {
            print("잘못된 URL 형식: \(imageNameOrUrl)")
            return nil
        }
        
        do {
            let imageData = try Data(contentsOf: url)
            if let uiImage = UIImage(data: imageData) {
                return uiImage
            } else {
                print("이미지 데이터를 UIImage로 변환 실패")
                return nil
            }
        } catch {
            print("URL에서 이미지 로드 실패: \(error.localizedDescription)")
            return nil
        }
    }
}
