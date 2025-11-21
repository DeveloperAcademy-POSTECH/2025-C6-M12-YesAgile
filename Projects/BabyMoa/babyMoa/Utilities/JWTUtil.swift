//
//  JWTUtil.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

final class JWTUtil {
    public static var shared = JWTUtil()
    private init() { }
    
    func decodeJWTPayload(jwtToken: String) throws -> [String: Any] {
        let components = jwtToken.components(separatedBy: ".")
        guard components.count == 3 else {
            throw JWTError.invalidTokenFormat
        }
        
        // 페이로드는 두 번째 부분
        let payload = components[1]
        
        // 메모
        // Base64 URL-safe 디코딩을 위한 문자열 처리
        // JWT는 Base64 URL-safe 인코딩을 사용하며, 패딩 문자('=')를 생략,
        // Swift의 Data(base64Encoded:)는 일반 Base64를 기대하므로,
        // URL-safe 문자를 표준 Base64 문자로 변환하고, 필요한 경우 패딩을 추가.
        var base64 = payload
            .replacingOccurrences(of: "-", with: "+") // '-'를 '+'로 변경
            .replacingOccurrences(of: "_", with: "/") // '_'를 '/'로 변경

        // Base64의 길이는 4의 배수여야 하므로, 패딩 문자('=')를 추가
        let requiredPadding = base64.count % 4
        if requiredPadding > 0 {
            base64 = base64.padding(toLength: base64.count + (4 - requiredPadding), withPad: "=", startingAt: 0)
        }

        // 3. Base64 디코딩
        guard let payloadData = Data(base64Encoded: base64) else {
            throw JWTError.base64DecodingFailed
        }

        // 4. JSON 디코딩 (JSONSerialization 사용)
        guard let jsonObject = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else {
            throw JWTError.jsonDecodingFailed
        }
        
        return jsonObject
    }
}

enum JWTError: Error {
    case invalidTokenFormat
    case base64DecodingFailed
    case jsonDecodingFailed
}
