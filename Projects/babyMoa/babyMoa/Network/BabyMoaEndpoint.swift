//
//  BabyMoaEndPoint.swift
//  babyMoa
//
//  Created by keonheehan on 10/30/25.
//

enum BabyMoaEndpoint: Endpoint {
    case appleLogin(idToken: String)
    case registerBaby(
        alias: String,
        name: String,
        birthDate: String,
        gender: String,
        avatarImageName: String,
        relationshipType: String
    )
    case registerBabyByCode(
        babyCode: String
    )
}

extension BabyMoaEndpoint {

    var path: String {
        switch self {
        case .appleLogin:
            return "/api/auth/apple/login"
        case .registerBaby:
            return "/api/baby/register_baby"
        case .registerBabyByCode:
            return "/api/baby/register_baby_by_code"
        }
    }

    var method: RequestMethod {
        switch self {
        case .appleLogin, .registerBaby, .registerBabyByCode:
            return .post
        }
    }

    var header: [String: String]? {
        switch self {
        case .appleLogin:
            return [
                "accept": "*/*",
                "Content-Type": "application/json",
            ]
        case .registerBaby:
            return [
                "accept": "*/*",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserToken.accessToken)",
            ]
        //공부 할것 체크
        case .registerBabyByCode:
            return [
                "accept": "*/*",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserToken.accessToken)",
            ]
        default:
            return nil
        }
    }

    var query: [String: String]? {
        switch self {
        default:
            return nil
        }
    }

    var body: [String: Any?]? {
        switch self {
        case .appleLogin(let idToken):
            return [
                "idToken": idToken
            ]
        case .registerBaby(
            let alias,
            let name,
            let birthDate,
            let gender,
            let avatarImageName,
            let relationshipType
        ):
            return [
                "alias": alias,
                "name": name,
                "birthDate": birthDate,
                "gender": gender,
                "avatarImageName": avatarImageName,
                "relationshipType": relationshipType,
            ]
        case .registerBabyByCode(let babyCode):
            return [
                "babyCode": babyCode
            ]
        default:
            return nil
        }
    }
}
