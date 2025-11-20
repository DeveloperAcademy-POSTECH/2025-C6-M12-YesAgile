//
//  AppleLoginResModel.swift
//  babyMoa
//
//  Created by keonheehan on 10/30/25.
//

struct AppleLoginResModel: ResponseModelable {
    var accessToken: String
    var refreshToken: String
    var tokenType: String
    
    func toDomain() async -> TokenResult {
        return TokenResult(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
