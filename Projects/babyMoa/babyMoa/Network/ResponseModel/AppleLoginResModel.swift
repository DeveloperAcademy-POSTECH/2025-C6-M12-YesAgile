//
//  AppleLoginResModel.swift
//  babyMoa
//
//  Created by keonheehan on 10/30/25.
//

struct AppleLoginResModel: Decodable {
    var accessToken: String
    var refreshToken: String
    var tokenType: String
}
