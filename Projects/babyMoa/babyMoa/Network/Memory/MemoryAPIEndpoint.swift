//
//  MemoryAPIEndpoint.swift
//  BabyMoaMap
//
//  Created by TaeHyeon Koo on 10/20/25.
//  추억(Memory) 기능 전용 API 엔드포인트
/// 포맷 가져가고 내용 수정

import Foundation


enum MemoryAPIEndpoint {
    // Memory (추억) API
    case uploadMemory
    case getMemories(babyId: Int64? = nil)  // baby_id로 필터링 가능
    case getMemory(id: Int64)
    case updateMemory(id: Int64)
    case deleteMemory(id: Int64)

    // ⚠️ 하위 호환성을 위한 별칭
    static var uploadPhoto: MemoryAPIEndpoint { .uploadMemory }
    static var getPhotos: MemoryAPIEndpoint { .getMemories() }
    static func getPhoto(id: String) -> MemoryAPIEndpoint {
        .getMemory(id: Int64(id) ?? 0)
    }
    static func deletePhoto(id: String) -> MemoryAPIEndpoint {
        .deleteMemory(id: Int64(id) ?? 0)
    }

    var path: String {
        switch self {
        case .uploadMemory:
            return "/api/memories"
        case .getMemories(let babyId):
            if let babyId = babyId {
                return "/api/memories?baby_id=\(babyId)"
            }
            return "/api/memories"
        case .getMemory(let id):
            return "/api/memories/\(id)"
        case .updateMemory(let id):
            return "/api/memories/\(id)"
        case .deleteMemory(let id):
            return "/api/memories/\(id)"
        }
    }

    var method: String {
        switch self {
        case .uploadMemory:
            return "POST"
        case .getMemories, .getMemory:
            return "GET"
        case .updateMemory:
            return "PUT"
        case .deleteMemory:
            return "DELETE"
        }
    }
}


