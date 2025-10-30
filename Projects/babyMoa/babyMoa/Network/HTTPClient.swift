//
//  HTTPClient.swift
//  babyMoa
//
//  Created by 한건희 on 10/30/25.
//

import Foundation

protocol HTTPClient {
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}


extension HTTPClient {
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        
        // MARK: --- 1. 서버 요청 정보 생성 ---
        // MARK: URLComponents : scheme, host, path, query
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        // MARK: 개발서버 - port 설정 필요, 프로덕션 서버에서는 포트 제거(host를 도메인으로 정)
        components.port = endpoint.port
        components.path = endpoint.path
        
        if let query = endpoint.query {
            components.queryItems = dictToQueryItems(query)
        }
        
        guard let url = components.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        do {
            // MARK: --- 2. 서버로의 api 요청 ---
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // MARK: --- 3. 서버 응답 처리 ---
            guard let response = response as? HTTPURLResponse else {
                return .failure(.decode)
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // WLogger.log("\(json)")
            }
            
            switch response.statusCode {
            case 200...299:
                do {
                        let decodeResponse = try JSONDecoder().decode(responseModel, from: data)
                        return .success(decodeResponse)
                    } catch let DecodingError.keyNotFound(key, context) {
                        //WLogger.error("Key not found: \(key.stringValue), codingPath: \(context.codingPath)")
                    } catch let DecodingError.typeMismatch(type, context) {
                        //WLogger.error("Type mismatch for type \(type), codingPath: \(context.codingPath)")
                    } catch let DecodingError.valueNotFound(type, context) {
                        //WLogger.error("Value not found for type \(type), codingPath: \(context.codingPath)")
                    } catch let DecodingError.dataCorrupted(context) {
                        //WLogger.error("Data corrupted: \(context.debugDescription)")
                    } catch {
                        // WLogger.error("Unknown decoding error: \(error.localizedDescription)")
                    }
                    
                    return .failure(.decode)
                
            case 400:
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let failureString = json["message"] as? String {
                        return .failure(.failureWithString(failureString))
                    }
                }
                return .failure(.failureWithString(""))
                
            case 401: // 인증 관련 에러
                return .failure(.unauthorized)
                
            case 500: // 서버 내부 에러
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let failureString = json["message"] as? String {
                        return .failure(.failureWithString(failureString))
                    }
                }
                return .failure(.failureWithString(""))
                
            default:
                // WLogger.log("data: \(data)")
                return .failure(.unexpectedStatusCode)
            }
            
        } catch {
            return .failure(.unknown)
        }
        
    }
    
    func dictToQueryItems(_ dict: [String: String]?) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        for (key, value) in dict ?? [:] {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        return queryItems
    }
}
