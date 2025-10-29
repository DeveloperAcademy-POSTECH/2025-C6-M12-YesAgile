////
////  PhotoService.swift
////  BabyMoaMap
////
////  비즈니스 로직을 담당하는 Service Layer
////  - 이미지 처리 (압축, 데이터 변환)
////  - 위치 정보 추출
////  - 사진 추가/삭제 로직
////
//추억탭 관련
//import Foundation
//import UIKit
//import Photos
//import CoreLocation
//
///// 사진 관련 비즈니스 로직을 처리하는 서비스
//class PhotoService {
//    // MARK: - Properties
//    
//    private let repository: PhotoRepository
//    private let locationManager: LocationManager
//    
//    // MARK: - Initialization
//    
//    init(
//        repository: PhotoRepository = PhotoRepository(),
//        locationManager: LocationManager = LocationManager()
//    ) {
//        self.repository = repository
//        self.locationManager = locationManager
//    }
//    
//    // MARK: - Public Methods
//    
//    /// 사진 추가 (PHAsset 사용)
//    func addPhoto(image: UIImage, asset: PHAsset?) async throws -> LocalPhoto {
//        // 1. 이미지 압축 및 데이터 변환
//        guard let imageData = compressImage(image) else {
//            throw PhotoServiceError.imageCompressionFailed
//        }
//        
//        // 2. 위치 정보 추출
//        let location = extractLocation(from: asset)
//        
//        // 3. 날짜 정보 추출
//        let date = asset?.creationDate ?? Date()
//        
//        // 4. LocalPhoto 생성
//        let photo = LocalPhoto(
//            imageData: imageData,
//            latitude: location.coordinate.latitude,
//            longitude: location.coordinate.longitude,
//            date: date
//        )
//        
//        // 5. Repository를 통해 저장
//        try repository.savePhoto(photo)
//        
//        logPhotoInfo(photo: photo, asset: asset)
//        
//        return photo
//    }
//    
//    /// 사진 추가 (메모와 날짜 포함)
//    func addPhoto(image: UIImage, memo: String, date: Date) async throws -> LocalPhoto {
//        // 1. 이미지 압축 및 데이터 변환
//        guard let imageData = compressImage(image) else {
//            throw PhotoServiceError.imageCompressionFailed
//        }
//        
//        // 2. 현재 위치 정보 추출
//        let location = extractLocation(from: nil)
//        
//        // 3. LocalPhoto 생성
//        let photo = LocalPhoto(
//            imageData: imageData,
//            memo: memo,
//            memoryDate: date,
//            latitude: location.coordinate.latitude,
//            longitude: location.coordinate.longitude
//        )
//        
//        // 4. Repository를 통해 저장
//        try repository.savePhoto(photo)
//        
//        print("✅ PhotoService: 사진 저장 - ID=\(photo.id), 메모=\(memo), 날짜=\(date)")
//        
//        return photo
//    }
//    
//    /// 모든 사진 불러오기
//    func loadPhotos() throws -> [LocalPhoto] {
//        return try repository.loadPhotos()
//    }
//    
//    /// 사진 삭제
//    func deletePhoto(_ photo: LocalPhoto) async throws {
//        try repository.deletePhoto(photo)
//        print("✅ PhotoService: 사진 삭제 - ID=\(photo.id)")
//    }
//    
//    /// 서버에 사진 업로드
//    func uploadPhoto(_ photo: LocalPhoto, babyId: Int64 = 1) async throws -> Memory {
//        return try await repository.uploadPhoto(photo, babyId: babyId)
//    }
//    
//    /// 서버에서 사진 가져오기
//    func fetchPhotosFromServer() async throws -> [Memory] {
//        return try await repository.fetchPhotosFromServer()
//    }
//    
//    /// 서버에서 사진 삭제
//    func deletePhotoFromServer(id: String) async throws {
//        try await repository.deletePhotoFromServer(id: id)
//    }
//    
//    // MARK: - Private Methods
//    
//    /// 이미지 압축
//    private func compressImage(_ image: UIImage, quality: CGFloat = 0.8) -> Data? {
//        return image.jpegData(compressionQuality: quality)
//    }
//    
//    /// 위치 정보 추출
//    /// - 1순위: PHAsset 메타데이터의 위치
//    /// - 2순위: 현재 위치
//    /// - 3순위: 기본 위치 (서울)
//    private func extractLocation(from asset: PHAsset?) -> CLLocation {
//        // 1. PHAsset에 위치 정보가 있으면 사용
//        if let asset = asset, let location = asset.location {
//            print("✅ PhotoService: 사진 메타데이터에 위치 정보 있음")
//            return location
//        }
//        
//        // 2. 현재 위치 사용
//        if let currentLocation = locationManager.location {
//            print("📍 PhotoService: 현재 위치 사용")
//            return currentLocation
//        }
//        
//        // 3. 기본 위치 (서울)
//        print("⚠️ PhotoService: 기본 위치 사용 (서울)")
//        return CLLocation(latitude: 37.5665, longitude: 126.9780)
//    }
//    
//    /// 로그 출력
//    private func logPhotoInfo(photo: LocalPhoto, asset: PHAsset?) {
//        if let asset = asset {
//            if asset.location != nil {
//                print("✅ PhotoService: 사진 저장 - ID=\(photo.id), 위치=사진 메타데이터")
//            } else {
//                print("⚠️ PhotoService: 사진 저장 - ID=\(photo.id), 위치=현재 위치")
//            }
//        } else {
//            print("📷 PhotoService: 사진 저장 - ID=\(photo.id), 위치=현재 위치")
//        }
//    }
//}
//
//// MARK: - Errors
//
//enum PhotoServiceError: LocalizedError {
//    case imageCompressionFailed
//    case locationNotAvailable
//    
//    var errorDescription: String? {
//        switch self {
//        case .imageCompressionFailed:
//            return "이미지 압축에 실패했습니다"
//        case .locationNotAvailable:
//            return "위치 정보를 가져올 수 없습니다"
//        }
//    }
//}
//
//
