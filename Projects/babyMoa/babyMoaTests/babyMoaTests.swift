//
//  babyMoaTests.swift
//  babyMoaTests
//
//  Created by keonheehan on 10/30/25.
//

import Testing
@testable import babyMoa

struct babyMoaTests {

    @Test func login() async {
        let idToken = ""
        let result = await BabyMoaService.shared.postAppleLogin(idToken: idToken)
        
        switch result {
        case .success(let success):
            if let loginResModel = success.data {
                UserToken.accessToken = loginResModel.accessToken
                UserToken.refreshToken = loginResModel.refreshToken
            }
            
        case .failure(let failure):
            print(failure)
        }
    }

    @Test func registerBaby() async {
        
        let result = await BabyMoaService.shared.postRegisterBaby(
            alias: "별명입니다",
            name: "응애자일",
            birthDate: "2025-10-01",
            gender: "M",
            avatarImageName: "dfdfddfdfsd",
            relationshipType: "FATHER"
        )
        
        switch result {
        case .success(let success):
            print(success)
        case .failure(let error):
            print(error)
        }
    }
}
