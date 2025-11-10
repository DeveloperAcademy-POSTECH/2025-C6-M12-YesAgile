//
//  BabyMoaService.swift
//  babyMoa
//
//  Created by 한건희 on 10/30/25.
//

protocol BabyMoaServicable: HTTPClient {
    func postAppleLogin(idToken: String) async -> Result<
        BaseResponse<AppleLoginResModel>, RequestError
    >
    func postRegisterBaby(
        alias: String,
        name: String,
        birthDate: String,
        gender: String,
        avatarImageName: String,
        relationshipType: String
    ) async -> Result<BaseResponse<RegisterBabyResModel>, RequestError>
    func updateBaby(
        babyId: Int,
        alias: String,
        name: String,
        birthDate: String,
        gender: String,
        avatarImageName: String,
        relationshipType: String
    ) async -> Result<BaseResponse<EmptyData>, RequestError>
    func postRegisterBabyByCode(babyCode: String) async -> Result<
        BaseResponse<RegisterBabyByCodeResModel>, RequestError
    >
    func postSetRelationshipWithBaby(babyId: Int, relationshipType: String)
        async -> Result<
            BaseResponse<EmptyData>, RequestError
        >
    func postSetTeethStatus(
        babyId: Int,
        teethId: Int,
        date: String,
        deletion: Bool

    ) async -> Result<
        BaseResponse<EmptyData>, RequestError
    >
    func getGetGrowthData(
        babyId: Int
    )
        async -> Result<
            BaseResponse<GetGrowthDataResModel>, RequestError
        >
    func getGetBabyList() async -> Result<
        BaseResponse<[GetBabyListResModel]>, RequestError
    >
    func postSetWeight(
        babyId: Int,
        weight: Double,
        date: String,
        memo: String?
    ) async -> Result<
        BaseResponse<EmptyData>, RequestError
    >
    func postSetHeight(
        babyId: Int,
        height: Double,
        date: String,
        memo: String?
    ) async -> Result<
        BaseResponse<EmptyData>, RequestError
    >
    func getGetWeights(
        babyId: Int
    ) async -> Result<
        BaseResponse<[GetWeightsResModel]>, RequestError
    >
    func getGetHeights(
        babyId: Int
    ) async -> Result<
        BaseResponse<[GetHeightsResModel]>, RequestError
    >
    func postAuthRefresh(
        refreshToken: String
    ) async -> Result<
        BaseResponse<AuthRefreshResModel>, RequestError
    >
    func postAddJourney(
        babyId: Int,
        journeyImage: String,
        latitude: Double,
        longitude: Double,
        date: String,
        memo: String
    ) async -> Result<
        BaseResponse<EmptyData>, RequestError
    >
    func postSetBabyMilestone(
        babyId: Int,
        milestoneName: String,
        milestoneImage: String,
        date: String,
        memo: String?
    ) async -> Result<
        BaseResponse<EmptyData>, RequestError
    >

    func getBaby(babyId: Int) async -> Result<
        BaseResponse<GetBabyResModel>, RequestError
    >
    func getGetJourniesAtMonth(
        babyId: Int,
        year: Int,
        month: Int
    ) async -> Result<BaseResponse<[GetJourniesAtMonthResModel]>, RequestError>
    func getGetBabyMilestones(
        babyId: Int
    ) async -> Result<BaseResponse<[GetBabyMilestonesResModel]>, RequestError>
    
    func deleteBabyMilestone(
        babyId: Int,
        milestoneName: String
    ) async -> Result<BaseResponse<EmptyData>, RequestError>

    func getBabyInviteCode(babyId: Int) async -> Result<BaseResponse<String>, RequestError>
    
    func deleteBaby(babyId: Int) async -> Result<BaseResponse<EmptyData>, RequestError>
}

class BabyMoaService: BabyMoaServicable {
    func updateBaby(babyId: Int, alias: String, name: String, birthDate: String, gender: String, avatarImageName: String, relationshipType: String) async -> Result<BaseResponse<EmptyData>, RequestError> {
        let result = await request(endpoint: BabyMoaEndpoint.updateBaby(babyId: babyId, alias: alias, name: name, birthDate: birthDate, gender: gender, avatarImageName: avatarImageName, relationshipType: relationshipType), responseModel: BaseResponse<EmptyData>.self)
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await request(endpoint: BabyMoaEndpoint.updateBaby(babyId: babyId, alias: alias, name: name, birthDate: birthDate, gender: gender, avatarImageName: avatarImageName, relationshipType: relationshipType), responseModel: BaseResponse<EmptyData>.self)
            default:
                return result
            }
        }
    }
    
    func deleteBaby(babyId: Int) async -> Result<BaseResponse<EmptyData>, RequestError> {
        let result = await request(endpoint: BabyMoaEndpoint.deleteBaby(babyId: babyId), responseModel: BaseResponse<EmptyData>.self)
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await request(endpoint: BabyMoaEndpoint.deleteBaby(babyId: babyId), responseModel: BaseResponse<EmptyData>.self)
            default:
                return result
            }
        }
    }
    
    func deleteBabyMilestone(babyId: Int, milestoneName: String) async -> Result<BaseResponse<EmptyData>, RequestError> {
        let result = await request(endpoint: BabyMoaEndpoint.deleteBabyMilestone(babyId: babyId, milestoneName: milestoneName), responseModel: BaseResponse<EmptyData>.self)
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await request(endpoint: BabyMoaEndpoint.deleteBabyMilestone(babyId: babyId, milestoneName: milestoneName), responseModel: BaseResponse<EmptyData>.self)
            default:
                return result
            }
        }
    }

    /// 아기 초대 코드를 가져오는 API 호출 메서드
    /// - Parameter babyId: 초대 코드를 가져올 아기의 ID
    /// - Returns: 초대 코드 문자열 또는 에러
    func getBabyInviteCode(babyId: Int) async -> Result<BaseResponse<String>, RequestError> {
        let result = await request(endpoint: BabyMoaEndpoint.getBabyInviteCode(babyId: babyId), responseModel: BaseResponse<String>.self)
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await request(endpoint: BabyMoaEndpoint.getBabyInviteCode(babyId: babyId), responseModel: BaseResponse<String>.self)
            default:
                return result
            }
        }
    }
    
    func getGetBabyMilestones(babyId: Int) async -> Result<
        BaseResponse<[GetBabyMilestonesResModel]>, RequestError
    > {
        let result = await request(
            endpoint: BabyMoaEndpoint.getBabyMilestones(
                babyId: babyId
            ),
            responseModel: BaseResponse<[GetBabyMilestonesResModel]>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.getGetBabyMilestones(
                    babyId: babyId
                )
            default:
                return result
            }
        }
    }
    func getGetJourniesAtMonth(
        babyId: Int,
        year: Int,
        month: Int
    ) async -> Result<BaseResponse<[GetJourniesAtMonthResModel]>, RequestError>
    {
        let result = await request(
            endpoint: BabyMoaEndpoint.getJourniesAtMonth(
                babyId: babyId,
                year: year,
                month: month
            ),
            responseModel: BaseResponse<[GetJourniesAtMonthResModel]>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.getGetJourniesAtMonth(
                    babyId: babyId,
                    year: year,
                    month: month
                )
            default:
                return result
            }
        }
    }
    func postSetBabyMilestone(
        babyId: Int,
        milestoneName: String,
        milestoneImage: String,
        date: String,
        memo: String?
    ) async -> Result<BaseResponse<EmptyData>, RequestError> {
        let result = await request(
            endpoint: BabyMoaEndpoint.setBabyMilestone(
                babyId: babyId,
                milestoneName: milestoneName,
                milestoneImage: milestoneImage,
                date: date,
                memo: memo
            ),
            responseModel: BaseResponse<EmptyData>.self
        )

        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.postSetBabyMilestone(
                    babyId: babyId,
                    milestoneName: milestoneName,
                    milestoneImage: milestoneImage,
                    date: date,
                    memo: memo
                )
            default:
                return result
            }
        }
    }

    func postAddJourney(
        babyId: Int,
        journeyImage: String,
        latitude: Double,
        longitude: Double,
        date: String,
        memo: String
    ) async -> Result<BaseResponse<EmptyData>, RequestError> {
        let result = await request(
            endpoint: BabyMoaEndpoint.addJourney(
                babyId: babyId,
                journeyImage: journeyImage,
                latitude: latitude,
                longtitude: longitude,
                date: date,
                memo: memo
            ),
            responseModel: BaseResponse<EmptyData>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.postAddJourney(
                    babyId: babyId,
                    journeyImage: journeyImage,
                    latitude: latitude,
                    longitude: longitude,
                    date: date,
                    memo: memo
                )
            default:
                return result
            }
        }
    }

    func postAuthRefresh(refreshToken: String) async -> Result<
        BaseResponse<AuthRefreshResModel>, RequestError
    > {
        let result = await request(
            endpoint: BabyMoaEndpoint.authRefresh(refreshToken: refreshToken),
            responseModel: BaseResponse<AuthRefreshResModel>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            print(error)
            return result
        }
    }

    func getGetHeights(babyId: Int) async -> Result<
        BaseResponse<[GetHeightsResModel]>, RequestError
    > {
        let result = await request(
            endpoint: BabyMoaEndpoint.getHeights(
                babyId: babyId
            ),
            responseModel: BaseResponse<[GetHeightsResModel]>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.getGetHeights(
                    babyId: babyId
                )
            default:
                return result
            }
        }
    }
    func getGetWeights(babyId: Int) async -> Result<
        BaseResponse<[GetWeightsResModel]>, RequestError
    > {
        let result = await request(
            endpoint: BabyMoaEndpoint.getWeights(
                babyId: babyId
            ),
            responseModel: BaseResponse<[GetWeightsResModel]>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.getGetWeights(
                    babyId: babyId
                )
            default:
                return result
            }
        }
    }

    func postSetHeight(babyId: Int, height: Double, date: String, memo: String?) async
        -> Result<BaseResponse<EmptyData>, RequestError>
    {
        let result = await request(
            endpoint: BabyMoaEndpoint.setHeight(
                babyId: babyId,
                height: height,
                date: date,
                memo: memo
            ),
            responseModel: BaseResponse<EmptyData>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.postSetHeight(
                    babyId: babyId,
                    height: height,
                    date: date,
                    memo: memo
                )
            default:
                return result
            }
        }
    }

    func postSetWeight(babyId: Int, weight: Double, date: String, memo: String?) async
        -> Result<BaseResponse<EmptyData>, RequestError>
    {
        let result = await request(
            endpoint: BabyMoaEndpoint.setWeight(
                babyId: babyId,
                weight: weight,
                date: date,
                memo: memo
            ),
            responseModel: BaseResponse<EmptyData>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.postSetWeight(
                    babyId: babyId,
                    weight: weight,
                    date: date,
                    memo: memo
                )
            default:
                return result
            }
        }
    }
    func getGetBabyList() async -> Result<
        BaseResponse<[GetBabyListResModel]>, RequestError
    > {
        let result = await request(
            endpoint: BabyMoaEndpoint.getBabyList,
            responseModel: BaseResponse<[GetBabyListResModel]>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.getGetBabyList()
            default:
                return result
            }
        }
    }

    func getBaby(babyId: Int) async -> Result<
        BaseResponse<GetBabyResModel>, RequestError
    > {
        return await request(
            endpoint: BabyMoaEndpoint.getBaby(babyId: babyId),
            responseModel: BaseResponse<GetBabyResModel>.self
        )
    }

    func getGetGrowthData(babyId: Int) async -> Result<
        BaseResponse<GetGrowthDataResModel>, RequestError
    > {
        let result = await request(
            endpoint: BabyMoaEndpoint.getGrowthData(babyId: babyId),
            responseModel: BaseResponse<GetGrowthDataResModel>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.getGetGrowthData(babyId: babyId)
            default:
                return result
            }
        }
    }
    func postSetTeethStatus(
        babyId: Int,
        teethId: Int,
        date: String,
        deletion: Bool
    ) async -> Result<
        BaseResponse<EmptyData>,
        RequestError
    > {
        let result = await request(
            endpoint:
                BabyMoaEndpoint.setTeethStatus(
                    babyId: babyId,
                    teethId: teethId,
                    date: date,
                    deletion: deletion
                ),
            responseModel: BaseResponse<EmptyData>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.postSetTeethStatus(
                    babyId: babyId,
                    teethId: teethId,
                    date: date,
                    deletion: deletion
                )
            default:
                return result
            }
        }
    }

    func postSetRelationshipWithBaby(
        babyId: Int,
        relationshipType: String
    ) async -> Result<
        BaseResponse<EmptyData>,
        RequestError
    > {
        let result = await request(
            endpoint: BabyMoaEndpoint.setRelationshipWithBaby(
                babyId: babyId,
                relationshipType: relationshipType
            ),
            responseModel:
                BaseResponse<EmptyData>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.postSetRelationshipWithBaby(
                    babyId: babyId,
                    relationshipType: relationshipType
                )
            default:
                return result
            }
        }
    }
    func postRegisterBabyByCode(
        babyCode: String
    ) async -> Result<BaseResponse<RegisterBabyByCodeResModel>, RequestError> {
        let result = await request(
            endpoint:
                BabyMoaEndpoint.registerBabyByCode(babyCode: babyCode),
            responseModel: BaseResponse<RegisterBabyByCodeResModel>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.postRegisterBabyByCode(babyCode: babyCode)
            default:
                return result
            }
        }
    }
    func postRegisterBaby(
        alias: String,
        name: String,
        birthDate: String,
        gender: String,
        avatarImageName: String,
        relationshipType: String
    ) async -> Result<BaseResponse<RegisterBabyResModel>, RequestError> {
        let result = await request(
            endpoint: BabyMoaEndpoint.registerBaby(
                alias: alias,
                name: name,
                birthDate: birthDate,
                gender: gender,
                avatarImageName: avatarImageName,
                relationshipType: relationshipType
            ),
            responseModel: BaseResponse<RegisterBabyResModel>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized:
                await refreshToken()
                return await self.postRegisterBaby(
                    alias: alias,
                    name: name,
                    birthDate: birthDate,
                    gender: gender,
                    avatarImageName: avatarImageName,
                    relationshipType: relationshipType
                )
            default:
                return result
            }
        }
    }

    public static let shared = BabyMoaService()

    private init() {}

    func postAppleLogin(idToken: String) async -> Result<
        BaseResponse<AppleLoginResModel>, RequestError
    > {
        return await request(
            endpoint: BabyMoaEndpoint.appleLogin(idToken: idToken),
            responseModel: BaseResponse<AppleLoginResModel>.self
        )
    }
    
    private func refreshToken() async {
        let authResult = await postAuthRefresh(refreshToken: UserToken.refreshToken)
        switch authResult {
        case .success(let success):
            UserToken.accessToken = success.data!.accessToken
            UserToken.refreshToken = success.data!.refreshToken
        case .failure(let failure):
            print(failure)
        }
    }

}