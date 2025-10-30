//
//  APIService.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case serverError(String)
}

@Observable
class APIService: HttpClient {
    static let shared = APIService()
    
    // TODO: 실제 백엔드 URL로 변경
    private let baseURL = "http://yesagile.shop"
    
    private init() {}
    
    // MARK: - Baby API
    
    /// 아기 정보 추가 API
    /// - Parameters:
    ///   - profileImage: 프로필 이미지 (옵션)
    ///   - gender: 성별 ("M", "F", "N")
    ///   - name: 이름 (옵션)
    ///   - nickname: 태명 (필수)
    ///   - birthDate: 출생일 또는 출생 예정일
    ///   - relationship: 아이와의 관계
    ///   - isPregnant: 임신 상태 (태명 등록 시 true)
    /// - Returns: Baby 모델
    func createBaby(
        profileImage: UIImage?,
        gender: String,
        name: String?,
        nickname: String,
        birthDate: Date,
        relationship: String,
        isPregnant: Bool? = nil
    ) async throws -> Baby {
        
        let endpoint = "\(baseURL)/babies"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        // 이미지를 Base64 문자열로 변환 (옵션)
        var profileImageString: String? = nil
        if let image = profileImage,
           let imageData = image.jpegData(compressionQuality: 0.7) {
            profileImageString = imageData.base64EncodedString()
        }
        
        // CreateBabyRequest 생성 (Date → String 자동 변환)
        let requestBody = CreateBabyRequest(
            profileImage: profileImageString,
            gender: gender,
            name: name,
            nickname: nickname,
            birthDate: birthDate,
            relationship: relationship,
            isPregnant: isPregnant
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // AccessToken을 Authorization 헤더에 추가
        // TokenManager에서 저장된 토큰을 가져옴
        if let token = TokenManager.shared.loadAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ [APIService] AccessToken이 없습니다")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            throw NetworkError.decodingError(error)
        }
        
        do {
            // 첫 번째 시도: API 요청
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // 401 Unauthorized: AccessToken 만료
            // → TokenManager를 통해 자동 갱신 후 재시도
            if httpResponse.statusCode == 401 {
                print("⚠️ [APIService] 401 Unauthorized - 토큰 갱신 시도")
                
                // TokenManager로 토큰 갱신 후 재시도
                let (retryData, retryResponse) = try await TokenManager.shared.retryWithRefreshedToken(originalRequest: request)
                
                guard let retryHttpResponse = retryResponse as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard (200...299).contains(retryHttpResponse.statusCode) else {
                    throw NetworkError.serverError("Retry failed: \(retryHttpResponse.statusCode)")
                }
                
                // 재시도 성공 → 응답 파싱
                let createResponse = try JSONDecoder().decode(CreateBabyResponse.self, from: retryData)
                
                guard let babyData = createResponse.data,
                      let baby = babyData.baby else {
                    throw NetworkError.serverError(createResponse.message ?? "No baby data returned")
                }
                
                return baby
            }
            
            // 200번대가 아니면 에러
            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorResponse = try? JSONDecoder().decode(APIError.self, from: data) {
                    throw NetworkError.serverError(errorResponse.message)
                }
                throw NetworkError.serverError("Server error: \(httpResponse.statusCode)")
            }
            
            let createResponse = try JSONDecoder().decode(CreateBabyResponse.self, from: data)
            
            guard let babyData = createResponse.data,
                  let baby = babyData.baby else {
                throw NetworkError.serverError(createResponse.message ?? "No baby data returned")
            }
            
            return baby
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    /// 아기 목록 조회 API
    func getBabies() async throws -> [Baby] {
        let endpoint = "\(baseURL)/babies"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // AccessToken 추가
        if let token = TokenManager.shared.loadAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // 401 Unauthorized: 토큰 갱신 후 재시도
            if httpResponse.statusCode == 401 {
                let (retryData, retryResponse) = try await TokenManager.shared.retryWithRefreshedToken(originalRequest: request)
                
                guard let retryHttpResponse = retryResponse as? HTTPURLResponse,
                      (200...299).contains(retryHttpResponse.statusCode) else {
                    throw NetworkError.serverError("Retry failed")
                }
                
                let getBabiesResponse = try JSONDecoder().decode(GetBabiesResponse.self, from: retryData)
                return getBabiesResponse.data ?? []
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError("Server error: \(httpResponse.statusCode)")
            }
            
            let getBabiesResponse = try JSONDecoder().decode(GetBabiesResponse.self, from: data)
            return getBabiesResponse.data ?? []
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // MARK: - Helper Methods
    
    func uploadImage(_ image: UIImage) async throws -> String {
        // TODO: 이미지를 별도로 업로드하는 API가 있다면 구현
        // 현재는 Base64로 직접 전송
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw NetworkError.serverError("Failed to convert image")
        }
        return imageData.base64EncodedString()
    }
}

