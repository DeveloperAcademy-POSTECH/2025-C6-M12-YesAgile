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
        date: String,  // "2025-11-02"
        memo: String?
    )
    case setHeight(
        babyId: Int,
        height: Double,
        date: String,  // "2025-11-02"
        memo: String?
    )
    case getWeights(
        babyId: Int
    )
    case getHeights(
        babyId: Int
    )
    case authRefresh(
        refreshToken: String
    )
    case addJourney(
        babyId: Int,
        journeyImage: String,
        latitude: Double,
        longtitude: Double,
        date: String,
        memo: String
    )
    case setBabyMilestone(
        babyId: Int,
        milestoneName: String,
        milestoneImage: String,
        date: String,
        memo: String?
    )
    case getBaby(
        babyId: Int
    )
    case getJourniesAtMonth(
        babyId: Int,
        year : Int,
        month : Int
    )
    case getBabyMilestones(
        babyId : Int
    )
    /// milestoneName의 경우, GrowthMilestone 구조체에서 사용하는 "milestone_0_1" 형식인 milestoneId 를 의미합니다.
    case deleteBabyMilestone(
        babyId: Int,
        milestoneName: String
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
        case .authRefresh:
            return "/api/auth/refresh"
        case .addJourney:
            return "/api/journey/add_journey"
        case .setBabyMilestone:
            return "/api/milestones/set_baby_milestone"
        case .getBaby:
            return "/api/baby/get_baby"
        case .getJourniesAtMonth:
            return "/api/journey/get_journies_at_month"
        case .getBabyMilestones:
            return "/api/milestones/get_baby_milestones"
        case .deleteBabyMilestone:
            return "/api/milestones/delete_milestone"
        }
    }

    var method: RequestMethod {
        switch self {
        case .appleLogin, .registerBaby, .registerBabyByCode,
            .setRelationshipWithBaby, .setTeethStatus, .setWeight, .setHeight,
            .authRefresh, .addJourney, .setBabyMilestone:
            return .post

        case .getGrowthData, .getBabyList, .getWeights, .getHeights, .getBaby, .getJourniesAtMonth, .getBabyMilestones:
            return .get
        
        case .deleteBabyMilestone:
            return .delete
        }
    }

    var header: [String: String]? {
        switch self {
        case .appleLogin, .authRefresh:
            return [
                "accept": "*/*",
                "Content-Type": "application/json",
            ]

        case .registerBaby, .registerBabyByCode, .setRelationshipWithBaby,
            .getGrowthData, .setTeethStatus, .getBabyList, .setWeight,
            .setHeight, .getWeights, .getHeights, .addJourney,
            .setBabyMilestone, .getBaby, .getJourniesAtMonth,
            .getBabyMilestones, .deleteBabyMilestone:
            return [
                "accept": "*/*",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserToken.accessToken)",
            ]
        }
    }

    var query: [String: String]? {
        switch self {
        case .getHeights(let babyId):
            return [
                "babyId" : String(babyId)
            ]
        case .getGrowthData(let babyId):
            return [
                "babyId" : String(babyId)
            ]
        case .getWeights(let babyId):
            return [
                "babyId" : String(babyId)
            ]
        case .getBaby(let babyId):
            return [
                "babyId": String(babyId)
            ]
        case .getJourniesAtMonth(let babyId,
                                 let year,
                                 let month):
            return [
                "babyId" : String(babyId),
                "year" : String(year),
                "month" : String(month)
            ]
        case .getBabyMilestones(let babyId):
            return [
                "babyId" : String(babyId)
            ]
        case .deleteBabyMilestone(
            let babyId,
            let milestoneName
        ):
            return [
                "babyId": String(babyId),
                "milestoneName": milestoneName
            ]
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
        case .setWeight(
            let babyId,
            let weight,
            let date,
            let memo
        ):
            if let memo = memo {
                return [
                    "babyId": babyId,
                    "weight": weight,
                    "date": date,
                    "memo": memo
                ]
            }
            return [
                "babyId": babyId,
                "weight": weight,
                "date": date,
                "memo": memo
            ]
        case .setHeight(
            let babyId,
            let height,
            let date,
            let memo
        ):
            if let memo = memo {
                return [
                    "babyId": babyId,
                    "height": height,
                    "date": date,
                    "memo": memo
                ]
            }
            return [
                "babyId": babyId,
                "height": height,
                "date": date
            ]
        case .authRefresh(
            let refreshToken
        ):
            return [
                "refreshToken": refreshToken

            ]
        case .addJourney(
            let babyId,
            let journeyImage,
            let latitude,
            let longitude,
            let date,
            let memo
        ):
            return [
                "babyId": babyId,
                "journeyImage": journeyImage,
                "latitude": latitude,
                "longitude": longitude,
                "date": date,
                "memo": memo,
            ]
        case .setBabyMilestone(
            let babyId,
            let milestoneName,
            let milestoneImage,
            let date,
            let memo
        ):
            if let memo = memo {
                return [
                    "babyId": babyId,
                    "milestoneName": milestoneName,
                    "milestoneImage": milestoneImage,
                    "date": date,
                    "memo": memo,
                ]
            }
            return [
                "babyId": babyId,
                "milestoneName": milestoneName,
                "milestoneImage": milestoneImage,
                "date": date
            ]

        // case 없이도 가능
        default:
            return nil
        }
    }
}
