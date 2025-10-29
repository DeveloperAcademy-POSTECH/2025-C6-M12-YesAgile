//
//  MemoryAPIClient.swift
//  BabyMoaMap
// 모든 API AccessToken 들어가야함.
//  Created by TaeHyeon Koo on 10/20/25.
//  추억(Memory) 기능 전용 API 클라이언트
/// 그대로 사용 예정

import Foundation

protocol MemoryAPIClientProtocol {
    func request<T: Decodable>(_ endpoint: MemoryAPIEndpoint, body: Encodable?)
        async throws -> T
}

/// 추억(Memory) 서버 API 통신을 담당하는 클라이언트
/// - Decodable을 활용한 자동 JSON 파싱
/// - Generic을 통한 타입 안전성 보장
class MemoryAPIClient: MemoryAPIClientProtocol {
    static let shared = MemoryAPIClient()

    // TODO: 실제 서버 URL로 변경 (예: "https://api.babymoa.com")
    private let baseURL = "https://your-api-server.com"

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(session: URLSession = .shared) {
        self.session = session

        // JSON Decoder 설정
        self.decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601  // ISO 8601 날짜 형식 (예: "2024-01-20T12:00:00Z")

        // JSON Encoder 설정
        self.encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
    }

    /// 서버에 API 요청을 보내고 응답을 Decodable 타입으로 반환
    /// - Parameters:
    ///   - endpoint: API 엔드포인트
    ///   - body: 요청 본문 (POST, PUT 등에 사용)
    /// - Returns: Decodable 프로토콜을 따르는 응답 객체
    func request<T: Decodable>(_ endpoint: MemoryAPIEndpoint, body: Encodable? = nil)
        async throws -> T
    {
        guard let url = URL(string: baseURL + endpoint.path) else {
            print("❌ [Memory API] Invalid URL: \(baseURL + endpoint.path)")
            throw MemoryNetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        // Authorization 헤더 추가
        // TokenManager에서 저장된 AccessToken을 가져와서 헤더에 포함
        if let token = TokenManager.shared.loadAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ [Memory API] AccessToken이 없습니다")
        }

        // Request Body 추가
        if let body = body {
            do {
                request.httpBody = try encoder.encode(body)
                if let bodyString = String(
                    data: request.httpBody!,
                    encoding: .utf8
                ) {
                    print("📤 [Memory API] Request Body: \(bodyString)")
                }
            } catch {
                print("❌ [Memory API] Encoding error: \(error)")
                throw MemoryNetworkError.unknown(error)
            }
        }

        // API 요청 로깅
        print("🌐 [Memory API] \(endpoint.method) \(url.absoluteString)")

        // 요청 실행
        do {
            // 첫 번째 시도: API 요청
            let (data, response) = try await session.data(for: request)

            // 응답 확인
            guard let httpResponse = response as? HTTPURLResponse else {
                throw MemoryNetworkError.unknown(
                    NSError(domain: "Invalid response", code: -1)
                )
            }

            print("✅ [Memory API] Response Status: \(httpResponse.statusCode)")

            // 응답 데이터 로깅 (디버그용)
            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 [Memory API] Response: \(responseString.prefix(200))...")
            }

            // 401 Unauthorized: AccessToken 만료
            // → TokenManager를 통해 자동 갱신 후 재시도
            if httpResponse.statusCode == 401 {
                print("⚠️ [Memory API] 401 Unauthorized - 토큰 갱신 시도")
                
                // TokenManager로 토큰 갱신 후 재시도
                let (retryData, retryResponse) = try await TokenManager.shared.retryWithRefreshedToken(originalRequest: request)
                
                guard let retryHttpResponse = retryResponse as? HTTPURLResponse else {
                    throw MemoryNetworkError.unknown(
                        NSError(domain: "Invalid retry response", code: -1)
                    )
                }
                
                print("✅ [Memory API] Retry Response Status: \(retryHttpResponse.statusCode)")
                
                // 재시도도 실패하면 에러
                guard 200...299 ~= retryHttpResponse.statusCode else {
                    throw MemoryNetworkError.serverError(retryHttpResponse.statusCode)
                }
                
                // 재시도 성공 → 응답 파싱
                let decodedResponse = try decoder.decode(T.self, from: retryData)
                return decodedResponse
            }

            // 200번대가 아니면 에러
            guard 200...299 ~= httpResponse.statusCode else {
                // 서버 에러 응답 파싱 시도
                if let errorResponse = try? decoder.decode(
                    APIErrorResponse.self,
                    from: data
                ) {
                    print("❌ [Memory API] Server Error: \(errorResponse.message)")
                }
                throw MemoryNetworkError.serverError(httpResponse.statusCode)
            }

            // Decodable을 사용한 자동 JSON 파싱
            do {
                let decodedResponse = try decoder.decode(T.self, from: data)
                return decodedResponse
            } catch {
                print("❌ [Memory API] Decoding error: \(error)")
                if let decodingError = error as? DecodingError {
                    printDecodingError(decodingError)
                }
                throw MemoryNetworkError.decodingError
            }

        } catch let error as MemoryNetworkError {
            throw error
        } catch {
            print("❌ [Memory API] Network error: \(error)")
            throw MemoryNetworkError.unknown(error)
        }
    }

    /// Decoding 에러 상세 정보 출력 (디버깅용)
    private func printDecodingError(_ error: DecodingError) {
        switch error {
        case .keyNotFound(let key, let context):
            print(
                "  ❌ Missing key '\(key.stringValue)' in \(context.debugDescription)"
            )
        case .typeMismatch(let type, let context):
            print(
                "  ❌ Type mismatch for type \(type) in \(context.debugDescription)"
            )
        case .valueNotFound(let type, let context):
            print(
                "  ❌ Value not found for type \(type) in \(context.debugDescription)"
            )
        case .dataCorrupted(let context):
            print("  ❌ Data corrupted: \(context.debugDescription)")
        @unknown default:
            print("  ❌ Unknown decoding error")
        }
    }
}

