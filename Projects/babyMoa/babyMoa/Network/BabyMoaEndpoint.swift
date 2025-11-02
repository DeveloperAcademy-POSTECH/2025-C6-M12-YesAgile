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
    case setRelationshipWithBaby(
        babyId: Int,
        relationshipType: String
    )
    case setTeethStatus(
        babyId: Int,
        teethId: Int,
        date: String,
        deletion: Bool
    )
    case getGrowthData(
        babyId: Int
    )
    case getBabyList

    case setWeight(
        babyId: Int,
        weight: Double,
        date: String  // "2025-11-02"
    )
    case setHeight(
        babyId: Int,
        height: Double,
        date: String  // "2025-11-02"
    )
    case getWeights(
        babyId: Int
    )
    case getHeights(
        babyId: Int
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
        case .setRelationshipWithBaby:
            return "/api/baby/set_relationship_with_baby"
        case .setTeethStatus:
            return "/api/baby/growth/set_teeth_status"
        case .getGrowthData:
            return "/api/baby/growth/get_growth_data"
        case .getBabyList:
            return "/api/baby/get_baby_list"
        case .setWeight:
            return "/api/growth/set_weight"
        case .setHeight:
            return "/api/growth/set_height"
        case .getWeights:
            return "/api/growth/get_weights"
        case .getHeights:
            return "/api/growth/get_heights"
        }
    }

    var method: RequestMethod {
        switch self {
        case .appleLogin, .registerBaby, .registerBabyByCode,
            .setRelationshipWithBaby, .setTeethStatus, .setWeight, .setHeight:
            return .post
        case .getGrowthData, .getBabyList, .getWeights, .getHeights:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .appleLogin:
            return [
                "accept": "*/*",
                "Content-Type": "application/json",
            ]
        case .registerBaby, .registerBabyByCode, .setRelationshipWithBaby,
            .getGrowthData, .setTeethStatus, .getBabyList, .setWeight,
            .setHeight, .getWeights, .getHeights:
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
        case .setRelationshipWithBaby(
            let babyId,
            let relationshipType
        ):
            return [
                "babyId": babyId,
                "relationshipType": relationshipType,
            ]
        case .setTeethStatus(
            let babyId,
            let teethID,
            let date,
            let deletion
        ):
            return [
                "babyId": babyId,
                "teethId": teethID,
                "date": date,
                "deletion": deletion,
            ]
        case .getGrowthData(
            let babyId,
        ):
            return [
                "babyId": babyId
            ]
        case .setWeight(
            let babyId,
            let weight,
            let date
        ):
            return [
                "babyId": babyId,
                "weight": weight,
                "date": date,
            ]
        case .setHeight(
            let babyId,
            let height,
            let date
        ):
            return [
                "babyId": babyId,
                "height": height,
                "date": date,
            ]
        case .getWeights(
            let babyId
        ):
            return [
                "babyId": babyId
            ]
        case .getHeights(
            let babyId
        ):
            return [
                "babyId": babyId
            ]

        // case 없이도 가능
        default:
            return nil
        }
    }
}
