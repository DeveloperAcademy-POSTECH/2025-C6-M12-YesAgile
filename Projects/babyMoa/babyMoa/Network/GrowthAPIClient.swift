//
//  GrowthAPIClient.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  성장 마일스톤 전용 API 클라이언트
//  - Authorization 헤더 삽입
//  - 401 대응(RefreshToken으로 AccessToken 갱신 후 재시도)
//  - JSON 및 멀티파트 업로드 지원
//

import Foundation
import UIKit

enum GrowthNetworkError: Error { case invalidURL, noData, decodingError, unauthorized, serverError(status: Int), unknown }

final class GrowthAPIClient {
    static let shared = GrowthAPIClient()
    private init() {}

    // MARK: - Core Request (JSON)
    func requestJSON<T: Decodable>(_ endpoint: GrowthAPIEndpoint, queryItems: [URLQueryItem]? = nil, body: Data? = nil, authorized: Bool = true, responseType: T.Type) async throws -> T {
        var request = try endpoint.makeURLRequest(queryItems: queryItems)
        if let body = body { request.httpBody = body }
        if authorized { try injectAuthorization(&request) }

        let (data, response) = try await URLSession.shared.data(for: request)
        if let http = response as? HTTPURLResponse {
            switch http.statusCode {
            case 200..<300:
                do { return try JSONDecoder().decode(T.self, from: data) } catch { throw GrowthNetworkError.decodingError }
            case 401:
                // 토큰 갱신 후 1회 재시도
                try await TokenManager.shared.refreshAccessToken()
                try injectAuthorization(&request)
                let (retryData, retryResp) = try await URLSession.shared.data(for: request)
                guard let retryHTTP = retryResp as? HTTPURLResponse, (200..<300).contains(retryHTTP.statusCode) else { throw GrowthNetworkError.unauthorized }
                do { return try JSONDecoder().decode(T.self, from: retryData) } catch { throw GrowthNetworkError.decodingError }
            default:
                throw GrowthNetworkError.serverError(status: http.statusCode)
            }
        }
        throw GrowthNetworkError.unknown
    }

    // MARK: - Multipart Upload (이미지 1장)
    func uploadImage(_ endpoint: GrowthAPIEndpoint, image: UIImage, fieldName: String = "file", fileName: String = "image.jpg", mimeType: String = "image/jpeg") async throws -> Data {
        var request = try endpoint.makeURLRequest()
        try injectAuthorization(&request)

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = GrowthHTTPMethod.POST.rawValue

        guard let imageData = image.jpegData(compressionQuality: 0.9) else { throw GrowthNetworkError.noData }

        // 바디 생성
        var body = Data()
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(imageData)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw GrowthNetworkError.unknown }
        switch http.statusCode {
        case 200..<300:
            return data
        case 401:
            try await TokenManager.shared.refreshAccessToken()
            try injectAuthorization(&request)
            let (retryData, retryResp) = try await URLSession.shared.data(for: request)
            guard let retryHTTP = retryResp as? HTTPURLResponse, (200..<300).contains(retryHTTP.statusCode) else { throw GrowthNetworkError.unauthorized }
            return retryData
        default:
            throw GrowthNetworkError.serverError(status: http.statusCode)
        }
    }

    // MARK: - Authorization
    private func injectAuthorization(_ request: inout URLRequest) throws {
        guard let token = TokenManager.shared.loadAccessToken() else { throw GrowthNetworkError.unauthorized }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}

// MARK: - Helper
private extension Data {
    mutating func appendString(_ string: String) { if let data = string.data(using: .utf8) { append(data) } }
}


