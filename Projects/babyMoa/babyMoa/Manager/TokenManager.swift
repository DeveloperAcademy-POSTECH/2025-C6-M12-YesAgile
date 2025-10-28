//
//  TokenManager.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  토큰 관리 전담 클래스
//  - AccessToken: 짧은 수명 (1시간), API 요청에 사용
//  - RefreshToken: 긴 수명 (2주~30일), AccessToken 재발급에 사용
//

import Foundation

/// 토큰 관리 및 자동 갱신을 담당하는 매니저
@Observable
class TokenManager {
    static let shared = TokenManager()

    // TODO: 실제 백엔드 URL로 변경
    private let baseURL = "https://api.example.com/v1"

    private init() {}

    // MARK: - 토큰 저장/로드

    /// AccessToken을 KeyChain에 저장
    /// - Parameter token: 저장할 AccessToken
    func saveAccessToken(_ token: String) {
        KeyChainHelper.save(key: "accessToken", value: token)
        print("✅ [TokenManager] AccessToken 저장 완료")
    }

    /// RefreshToken을 KeyChain에 저장
    /// - Parameter token: 저장할 RefreshToken
    func saveRefreshToken(_ token: String) {
        KeyChainHelper.save(key: "refreshToken", value: token)
        print("✅ [TokenManager] RefreshToken 저장 완료")
    }

    /// AccessToken을 KeyChain에서 로드
    /// - Returns: 저장된 AccessToken (없으면 nil)
    func loadAccessToken() -> String? {
        return KeyChainHelper.load(key: "accessToken")
    }

    /// RefreshToken을 KeyChain에서 로드
    /// - Returns: 저장된 RefreshToken (없으면 nil)
    func loadRefreshToken() -> String? {
        return KeyChainHelper.load(key: "refreshToken")
    }

    /// 모든 토큰 삭제 (로그아웃 시 사용)
    func clearAllTokens() {
        KeyChainHelper.delete(key: "accessToken")
        KeyChainHelper.delete(key: "refreshToken")
        KeyChainHelper.delete(key: "authToken")  // 기존 토큰도 삭제
        print("✅ [TokenManager] 모든 토큰 삭제 완료")
    }

    // MARK: - 토큰 갱신

    /// RefreshToken을 사용하여 새로운 AccessToken 발급
    /// - Returns: 새로운 AccessToken
    /// - Throws: 갱신 실패 시 에러
    func refreshAccessToken() async throws -> String {
        print("🔄 [TokenManager] AccessToken 갱신 시도...")

        // 1. RefreshToken 확인
        guard let refreshToken = loadRefreshToken() else {
            print("❌ [TokenManager] RefreshToken이 없습니다")
            throw TokenError.refreshTokenNotFound
        }

        // 2. API 엔드포인트 설정
        guard let url = URL(string: "\(baseURL)/auth/refresh") else {
            throw TokenError.invalidURL
        }

        // 3. 요청 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 4. RefreshToken을 Body에 포함
        let requestBody = RefreshTokenRequest(refreshToken: refreshToken)
        request.httpBody = try JSONEncoder().encode(requestBody)

        // 5. API 요청
        let (data, response) = try await URLSession.shared.data(for: request)

        // 6. 응답 확인
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TokenError.invalidResponse
        }

        // 7. 성공 여부 확인 (200번대)
        guard (200...299).contains(httpResponse.statusCode) else {
            print(
                "❌ [TokenManager] 토큰 갱신 실패 - 상태 코드: \(httpResponse.statusCode)"
            )

            // 401/403이면 RefreshToken도 만료됨 → 로그아웃 필요
            if httpResponse.statusCode == 401 || httpResponse.statusCode == 403
            {
                throw TokenError.refreshTokenExpired
            }

            throw TokenError.serverError(httpResponse.statusCode)
        }

        // 8. 응답 파싱
        let refreshResponse = try JSONDecoder().decode(
            RefreshTokenResponse.self,
            from: data
        )

        guard let newAccessToken = refreshResponse.accessToken else {
            throw TokenError.invalidResponse
        }

        // 9. 새 토큰들 저장
        saveAccessToken(newAccessToken)

        // RefreshToken도 새로 발급되면 저장 (선택적)
        if let newRefreshToken = refreshResponse.refreshToken {
            saveRefreshToken(newRefreshToken)
        }

        print("✅ [TokenManager] AccessToken 갱신 성공")

        return newAccessToken
    }

    // MARK: - 토큰 검증

    /// 401 오류 발생 시 자동으로 토큰 갱신 후 재시도
    /// - Parameter originalRequest: 실패한 원래 요청
    /// - Returns: 갱신 후 재시도한 응답
    func retryWithRefreshedToken(originalRequest: URLRequest) async throws -> (
        Data, URLResponse
    ) {
        print("🔄 [TokenManager] 토큰 갱신 후 재시도...")

        // 1. AccessToken 갱신
        let newAccessToken = try await refreshAccessToken()

        // 2. 원래 요청에 새 토큰 적용
        var retryRequest = originalRequest
        retryRequest.setValue(
            "Bearer \(newAccessToken)",
            forHTTPHeaderField: "Authorization"
        )

        // 3. 재시도
        let (data, response) = try await URLSession.shared.data(
            for: retryRequest
        )

        print("✅ [TokenManager] 재시도 완료")

        return (data, response)
    }
}

// MARK: - 요청/응답 모델

/// RefreshToken API 요청 모델
private struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

/// RefreshToken API 응답 모델
private struct RefreshTokenResponse: Codable {
    let success: Bool
    let accessToken: String?
    let refreshToken: String?  // 새 RefreshToken (선택적)
    let message: String?
}

// MARK: - 에러 정의

/// 토큰 관련 에러
enum TokenError: LocalizedError {
    case refreshTokenNotFound  // RefreshToken이 KeyChain에 없음
    case refreshTokenExpired  // RefreshToken도 만료됨 (재로그인 필요)
    case invalidURL  // 잘못된 API URL
    case invalidResponse  // 응답 파싱 실패
    case serverError(Int)  // 서버 오류

    var errorDescription: String? {
        switch self {
        case .refreshTokenNotFound:
            return "RefreshToken이 없습니다. 다시 로그인해주세요."
        case .refreshTokenExpired:
            return "세션이 만료되었습니다. 다시 로그인해주세요."
        case .invalidURL:
            return "잘못된 API 주소입니다."
        case .invalidResponse:
            return "서버 응답을 처리할 수 없습니다."
        case .serverError(let code):
            return "서버 오류가 발생했습니다. (코드: \(code))"
        }
    }
}
