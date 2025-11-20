//
//  ImageHelper.swift
//  babyMoa
//
//  Created by AI on 10/30/25.
//
//  이미지 파일 저장/로드 헬퍼

import UIKit

struct ImageHelper {
    
    // MARK: - Documents Directory
    
    /// Documents 디렉토리 경로
    private static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - Save Image
    
    /// 이미지를 Documents 디렉토리에 저장
    /// - Parameters:
    ///   - image: 저장할 UIImage
    ///   - babyId: 아기 ID
    /// - Returns: 저장된 파일명 (예: "baby_uuid123.jpg")
    static func saveImage(_ image: UIImage, forBabyId babyId: String) -> String? {
        let fileName = "baby_\(babyId).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ 이미지 데이터 변환 실패")
            return nil
        }
        
        do {
            try imageData.write(to: fileURL)
            print("✅ 이미지 저장 완료: \(fileName)")
            return fileName
        } catch {
            print("❌ 이미지 저장 실패: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Load Image
    
    /// Documents 디렉토리에서 이미지 로드
    /// - Parameter fileName: 파일명 (예: "baby_uuid123.jpg")
    /// - Returns: UIImage 또는 nil
    static func loadImage(fileName: String?) -> UIImage? {
        guard let fileName = fileName, !fileName.isEmpty else {
            return nil
        }
        
        // Assets에서 먼저 확인 (기본 이미지용)
        if let assetImage = UIImage(named: fileName) {
            return assetImage
        }
        
        // Documents 디렉토리에서 로드
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        guard let imageData = try? Data(contentsOf: fileURL),
              let image = UIImage(data: imageData) else {
            print("❌ 이미지 로드 실패: \(fileName)")
            return nil
        }
        
        return image
    }
    
    // MARK: - Delete Image
    
    /// Documents 디렉토리에서 이미지 삭제
    /// - Parameter fileName: 파일명 (예: "baby_uuid123.jpg")
    static func deleteImage(fileName: String?) {
        guard let fileName = fileName, !fileName.isEmpty else {
            return
        }
        
        // Assets 이미지는 삭제하지 않음
        if UIImage(named: fileName) != nil {
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("✅ 이미지 삭제 완료: \(fileName)")
        } catch {
            print("❌ 이미지 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Migrate from UserDefaults
    
    /// UserDefaults의 Base64 이미지를 파일로 마이그레이션
    /// - Parameter babyId: 아기 ID
    /// - Returns: 저장된 파일명
    static func migrateFromUserDefaults(babyId: String) -> String? {
        // UserDefaults에서 Base64 이미지 로드
        guard let base64String = UserDefaults.standard.string(forKey: "babyProfileImage"),
              let imageData = Data(base64Encoded: base64String),
              let image = UIImage(data: imageData) else {
            return nil
        }
        
        // 파일로 저장
        let fileName = saveImage(image, forBabyId: babyId)
        
        // UserDefaults에서 제거
        if fileName != nil {
            UserDefaults.standard.removeObject(forKey: "babyProfileImage")
            print("✅ Base64 이미지를 파일로 마이그레이션 완료: \(babyId)")
        }
        
        return fileName
    }
}

