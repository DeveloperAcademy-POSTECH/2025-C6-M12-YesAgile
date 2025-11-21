//
//  AuthRefreshResModel.swift
//  babyMoa
//
//  Created by pherd on 11/2/25.
//
struct AuthRefreshResModel: Decodable {
    var accessToken: String
    var refreshToken: String
    var tokenType: String

}
