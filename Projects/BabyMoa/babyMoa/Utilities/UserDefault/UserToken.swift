//
//  UserToken.swift
//  babyMoa
//
//  Created by keonheehan on 11/1/25.
//

import Foundation

struct UserToken {
    @UserDefault(key: "accessToken", defaultValue: "")
    static var accessToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    static var refreshToken: String
}
