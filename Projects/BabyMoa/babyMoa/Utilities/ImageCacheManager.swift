//
//  ImageCacheManager.swift
//  BabyMoa
//
//  Created by Baba on 11/20/25.
//
//

import UIKit
import Foundation

// MARK: - ImageCacheManager
final class ImageCacheManager {
    static let shared = ImageCacheManager()

    // MARK: - Properties
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let diskCacheDirectoryName = "ImageCache" // 디스크 캐시를 저장할 디렉토리 이름
    
    // MARK: - Initialization
    private init() {
        createDiskCacheDirectory()
    }

    // MARK: - Disk Cache Directory Management
    // 디스크 캐시 디렉토리 생성
    private func createDiskCacheDirectory() {
        guard let cacheDirectory = diskCacheURL else { return }
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create disk cache directory: \(error)")
            }
        }
    }

    // 앱의 캐시 디렉토리 내에 ImageCache 전용 URL 경로
    private var diskCacheURL: URL? {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(diskCacheDirectoryName)
    }

    // MARK: - Key Generation for Disk Cache
    // URL 문자열을 기반으로 디스크 파일명에 사용할 안전한 키 생성
    private func cacheKey(for urlString: String) -> String {
        // URL 문자열을 Percent-Encoding하여 파일명으로 안전하게 사용
        // 실제 운영 환경에서는 MD5나 SHA256 해시를 사용하여 더 견고한 키를 만드는 것이 일반적입니다.
        // 이는 URL이 너무 길거나 파일명으로 사용하기 부적절한 문자를 포함할 경우를 대비합니다.
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .alphanumerics.union(.init(charactersIn: "-_."))) {
            return encodedString
        }
        // 인코딩 실패 시 UUID를 사용하여 고유한 이름 생성
        return UUID().uuidString 
    }
    
    // 디스크 캐시에 저장될 파일의 전체 URL 경로
    private func getDiskCacheFileURL(forKey key: String) -> URL? {
        return diskCacheURL?.appendingPathComponent(key)
    }

    // MARK: - Public Methods
    
    /// 주어진 URL 문자열에 해당하는 이미지를 캐시에서 가져옵니다.
    /// (메모리 캐시 먼저 확인 후, 없으면 디스크 캐시 확인)
    func getImage(for urlString: String) -> UIImage? {
        let key = urlString as NSString // NSCache는 NSString 키를 사용

        // 1. 메모리 캐시 확인
        if let cachedImage = memoryCache.object(forKey: key) {
            print("✅ [Cache Hit] Image from MEMORY cache for: \(urlString)")
            return cachedImage
        }

        // 2. 디스크 캐시 확인
        let diskKey = cacheKey(for: urlString)
        if let fileURL = getDiskCacheFileURL(forKey: diskKey),
           let imageData = try? Data(contentsOf: fileURL),
           let image = UIImage(data: imageData) {
            
            // 디스크 캐시에서 찾으면 메모리 캐시에 저장 (다음 요청을 위해)
            memoryCache.setObject(image, forKey: key)
            print("✅ [Cache Hit] Image from DISK cache for: \(urlString)")
            return image
        }

        return nil // 캐시에 없음
    }

    /// 이미지를 캐시에 저장합니다. (메모리 캐시 및 디스크 캐시)
    /// - Parameters:
    ///   - image: 메모리 캐시에 저장할 UIImage 객체.
    ///   - imageData: 디스크 캐시에 저장할 원본 이미지 데이터 (Data?). UIImage를 Data로 변환하는 오버헤드를 줄이기 위해 원본 데이터를 선호합니다.
    ///   - urlString: 이미지의 원본 URL 문자열. 캐시 키로 사용됩니다.
    func setImage(_ image: UIImage, imageData: Data?, for urlString: String) {
        let key = urlString as NSString

        // 1. 메모리 캐시에 저장
        memoryCache.setObject(image, forKey: key)

        // 2. 디스크 캐시에 저장
        // 원본 imageData가 있으면 사용하고, 없으면 UIImage를 JPEG 데이터로 변환하여 저장
        guard let dataToSave = imageData ?? image.jpegData(compressionQuality: 0.8), 
              let fileURL = getDiskCacheFileURL(forKey: cacheKey(for: urlString)) else { return }
        
        do {
            try dataToSave.write(to: fileURL, options: .atomic) // .atomic 옵션으로 안전하게 파일 쓰기
            // print("Image saved to disk cache for \(urlString)") // 디버깅용
        } catch {
            print("Failed to save image to disk cache: \(error)")
        }
    }
    
    /// 메모리 캐시와 디스크 캐시를 모두 지웁니다.
    func clearCache() {
        // 메모리 캐시 지우기
        memoryCache.removeAllObjects()
        
        // 디스크 캐시 디렉토리 지우기
        guard let cacheDirectory = diskCacheURL else { return }
        do {
            try fileManager.removeItem(at: cacheDirectory)
            createDiskCacheDirectory() // 디렉토리를 다시 생성하여 비어있는 상태로 만듦
            print("Cache cleared: Memory and Disk.")
        } catch {
            print("Failed to clear disk cache: \(error)")
        }
    }
}
