import CoreLocation
//
//  MemoryData.swift
//  BabyMoaMap
//
//  Created by TaeHyeon Koo on 10/20/25.
//
//  Memory 모델 (백엔드 memory 테이블과 매핑)
//  백엔드 memory 테이블 스키마:
//  - memory_id (BIGINT, PK)
//  - baby_id (BIGINT, NN, FK)
//  - photo_url (VARCHAR(500))
//  - memo (VARCHAR(255))
//  - memory_date (DATE, NN)
//  - latitude (위치 정보 포함) ✅ 체크여부
//  - longitude (위치 정보 포함) ✅ 체크여부
//  - created_at (DATETIME)
//  - updated_at (DATETIME)
//  메모리 id 필요 여부 -> baby_id로만 충분하지않나?

import Foundation

// MARK: - Memory Model (서버와 통신용 - 백엔드 스키마 기반)
struct Memory: Identifiable, Codable, Equatable {
    let memoryId: Int64
    let babyId: Int64
    let photoUrl: String?
    let memo: String?
    let memoryDate: Date
    let createdAt: Date
    let updatedAt: Date?


    // 사진을 찍은 위치 또는 추억이 발생한 위치
    let latitude: Double?  // 위치 정보 없을 수도 있음
    let longitude: Double?  // 위치 정보 없을 수도 있음

    var id: Int64 { memoryId }

    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    enum CodingKeys: String, CodingKey {
        case memoryId = "memory_id"
        case babyId = "baby_id"
        case photoUrl = "photo_url"
        case memo // 이건 뭔지 체크.
        case memoryDate = "memory_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case latitude  // ✅ 백엔드 포함 확인하기
        case longitude  // ✅ 백엔드 포함 확인하기
    }
}

// ⚠️ 하위 호환성을 위한 typealias (기존 코드 동작)
typealias Photo = Memory

// MARK: - Memory Extension (하위 호환성)
extension Memory {
    /// 기존 Photo 인터페이스 호환
    var imageUrl: String? { photoUrl }
}

// MARK: - Local Memory (로컬 저장용 - 이미지 데이터 포함)
struct LocalMemory: Identifiable, Equatable {
    let id: String
    let babyId: Int64?  // 선택된 아기 ID
    let imageData: Data  // 로컬 이미지 데이터
    let memo: String?
    let memoryDate: Date
    let latitude: Double?
    let longitude: Double?

    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    init(
        id: String = UUID().uuidString,
        babyId: Int64? = nil,
        imageData: Data,
        memo: String? = nil,
        memoryDate: Date = Date(),
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.id = id
        self.babyId = babyId
        self.imageData = imageData
        self.memo = memo
        self.memoryDate = memoryDate
        self.latitude = latitude
        self.longitude = longitude
    }
}

// ⚠️ 하위 호환성을 위한 typealias (기존 코드 동작)
typealias LocalPhoto = LocalMemory

// MARK: - LocalPhoto 호환성 Extension
extension LocalMemory {
    /// 기존 LocalPhoto 인터페이스 호환
    var date: Date { memoryDate }

    /// 기존 코드와 호환되는 초기화 (위치 정보 필수)
    init(
        id: String = UUID().uuidString,
        imageData: Data,
        latitude: Double,
        longitude: Double,
        date: Date = Date()
    ) {
        self.init(
            id: id,
            babyId: nil,
            imageData: imageData,
            memo: nil,
            memoryDate: date,
            latitude: latitude,
            longitude: longitude
        )
    }
}

// MARK: - Memory Upload Request (서버 업로드용)
struct MemoryUploadRequest: Codable {
    let babyId: Int64
    let memo: String?
    let memoryDate: Date
    let latitude: Double?
    let longitude: Double?
    let imageBase64: String?  // Base64 인코딩된 이미지 (또는 멀티파트)

    enum CodingKeys: String, CodingKey {
        case babyId = "baby_id"
        case memo
        case memoryDate = "memory_date"
        case latitude
        case longitude
        case imageBase64 = "image_base64"
    }

    init(from localMemory: LocalMemory, babyId: Int64) {
        self.babyId = babyId
        self.memo = localMemory.memo
        self.memoryDate = localMemory.memoryDate
        self.latitude = localMemory.latitude
        self.longitude = localMemory.longitude
        self.imageBase64 = localMemory.imageData.base64EncodedString()
    }
}

// MARK: - Memory Response (서버 응답용)
struct MemoryResponse: Codable {
    let success: Bool
    let memory: Memory?
    let message: String?
}

// MARK: - MemoryResponse Extension (하위 호환성)
extension MemoryResponse {
    /// 기존 PhotoResponse 인터페이스 호환
    var photo: Memory? { memory }
}

// MARK: - Memories List Response (여러 추억 응답용)
struct MemoriesListResponse: Codable {
    let success: Bool
    let memories: [Memory]
    let totalCount: Int?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case success
        case memories
        case totalCount = "total_count"
        case message
    }
}

// MARK: - MemoriesListResponse Extension (하위 호환성)
extension MemoriesListResponse {
    /// 기존 PhotosListResponse 인터페이스 호환
    var photos: [Memory] { memories }
}

// ⚠️ 하위 호환성을 위한 typealias (기존 코드 동작)
typealias PhotoUploadRequest = MemoryUploadRequest
typealias PhotoResponse = MemoryResponse
typealias PhotosListResponse = MemoriesListResponse

// MARK: - Generic API Response (범용 응답 래퍼)
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: APIErrorResponse?
    let message: String?
}

// MARK: - API Error Response (서버 에러 상세 정보)
struct APIErrorResponse: Codable {
    let code: String
    let message: String
    let details: [String: String]?
}


