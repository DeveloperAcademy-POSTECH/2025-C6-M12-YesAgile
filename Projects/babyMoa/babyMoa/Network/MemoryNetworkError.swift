//
//  MemoryNetworkError.swift
//  BabyMoaMap
//
//  Created by TaeHyeon Koo on 10/20/25.
//  추억(Memory) 기능 전용 네트워크 에러
//

import Foundation

enum MemoryNetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .noData:
            return "데이터를 받지 못했습니다."
        case .decodingError:
            return "데이터 파싱에 실패했습니다."
        case .serverError(let code):
            return "서버 오류가 발생했습니다. (코드: \(code))"
        case .unknown(let error):
            return "알 수 없는 오류: \(error.localizedDescription)"
        }
    }
}


