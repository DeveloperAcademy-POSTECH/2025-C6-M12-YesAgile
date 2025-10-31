//
//  UserToken.swift
//  babyMoa
//
//  Created by keonheehan on 10/31/25.
//

struct UserToken {
    @UserDefault(key: "accessToken", defaultValue: "")
    static var accessToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    static var refreshToken: String
}
