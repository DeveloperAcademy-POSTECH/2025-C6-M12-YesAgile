//
//  PhotoRepository.swift
//  BabyMoaMap
//
//  데이터 접근을 담당하는 Repository Layer
//  - UserDefaults를 통한 로컬 저장소 관리
//  - APIClient를 통한 서버 통신
//

import Foundation

/// 사진 데이터의 저장과 불러오기를 담당하는 Repository
/// - Local: UserDefaults
/// - Remote: APIClient
class PhotoRepository {
    // MARK: - Properties
    
    private let apiClient: MemoryAPIClient
    private let userDefaults: UserDefaults
    private let storageKey = "local_photos"
    
    // MARK: - Initialization
    
    init(
        apiClient: MemoryAPIClient = MemoryAPIClient.shared,
        userDefaults: UserDefaults = .standard
    ) {
        self.apiClient = apiClient
        self.userDefaults = userDefaults
    }
    
    // MARK: - Local Storage (UserDefaults)
    
    /// 로컬에서 모든 사진 불러오기
    func loadPhotos() throws -> [LocalPhoto] {
        guard let data = userDefaults.data(forKey: storageKey) else {
            print("💾 PhotoRepository: 저장된 사진이 없습니다")
            return []
        }
        
        guard let decoded = try? JSONDecoder().decode([LocalPhotoDTO].self, from: data) else {
            throw RepositoryError.decodingFailed
        }
        
        let photos = decoded.map { dto in
            LocalMemory(
                id: dto.id,
                babyId: dto.babyId,
                imageData: dto.imageData,
                memo: dto.memo,
                memoryDate: dto.date,
                latitude: dto.latitude,
                longitude: dto.longitude
            )
        }
        
        print("✅ PhotoRepository: \(photos.count)개 사진 로드 완료")
        return photos
    }
    
    /// 로컬에 사진 저장
    func savePhoto(_ photo: LocalPhoto) throws {
        var photos = (try? loadPhotos()) ?? []
        photos.append(photo)
        try savePhotos(photos)
    }
    
    /// 로컬에서 사진 삭제
    func deletePhoto(_ photo: LocalPhoto) throws {
        var photos = try loadPhotos()
        photos.removeAll { $0.id == photo.id }
        try savePhotos(photos)
        print("✅ PhotoRepository: 사진 삭제 완료 - ID=\(photo.id)")
    }
    
    /// 로컬에 모든 사진 저장 (내부 메서드)
    private func savePhotos(_ photos: [LocalPhoto]) throws {
        let dtos = photos.map { photo in
            LocalPhotoDTO(
                id: photo.id,
                imageData: photo.imageData,
                latitude: photo.latitude,
                longitude: photo.longitude,
                date: photo.date,
                babyId: photo.babyId,
                memo: photo.memo
            )
        }
        
        guard let encoded = try? JSONEncoder().encode(dtos) else {
            throw RepositoryError.encodingFailed
        }
        
        userDefaults.set(encoded, forKey: storageKey)
        userDefaults.synchronize()
        print("💾 PhotoRepository: \(photos.count)개 사진 저장 완료")
    }
    
    // MARK: - Remote Storage (Server API)
    
    /// 서버에 사진 업로드
    func uploadPhoto(_ photo: LocalPhoto, babyId: Int64) async throws -> Memory {
        let request = MemoryUploadRequest(from: photo, babyId: babyId)
        
        let response: PhotoResponse = try await apiClient.request(
            .uploadPhoto,
            body: request
        )
        
        guard response.success, let uploadedPhoto = response.photo else {
            throw RepositoryError.uploadFailed
        }
        
        print("✅ PhotoRepository: 서버 업로드 성공 - ID=\(uploadedPhoto.id)")
        return uploadedPhoto
    }
    
    /// 서버에서 모든 사진 가져오기
    func fetchPhotosFromServer() async throws -> [Memory] {
        let response: PhotosListResponse = try await apiClient.request(
            .getPhotos,
            body: nil as String?
        )
        
        print("✅ PhotoRepository: 서버에서 \(response.photos.count)개 사진 가져오기 성공")
        return response.photos
    }
    
    /// 서버에서 사진 삭제
    func deletePhotoFromServer(id: String) async throws {
        struct DeleteResponse: Codable {
            let success: Bool
            let message: String?
        }
        
        let response: DeleteResponse = try await apiClient.request(
            .deletePhoto(id: id),
            body: nil as String?
        )
        
        guard response.success else {
            throw RepositoryError.deleteFailed
        }
        
        print("✅ PhotoRepository: 서버에서 사진 삭제 성공 - ID=\(id)")
    }
}

// MARK: - DTO for UserDefaults

/// UserDefaults 저장을 위한 DTO
private struct LocalPhotoDTO: Codable {
    let id: String
    let imageData: Data
    let latitude: Double?
    let longitude: Double?
    let date: Date
    let babyId: Int64?
    let memo: String?
}

// MARK: - Errors

enum RepositoryError: LocalizedError {
    case encodingFailed
    case decodingFailed
    case uploadFailed
    case deleteFailed
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "데이터 인코딩에 실패했습니다"
        case .decodingFailed:
            return "데이터 디코딩에 실패했습니다"
        case .uploadFailed:
            return "서버 업로드에 실패했습니다"
        case .deleteFailed:
            return "서버 삭제에 실패했습니다"
        case .notFound:
            return "데이터를 찾을 수 없습니다"
        }
    }
}


