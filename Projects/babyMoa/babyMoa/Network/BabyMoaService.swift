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
    func postRegisterBabyByCode(babyCode: String) async -> Result<
        BaseResponse<RegisterBabyByCodeResModel>, RequestError
    >
    func postSetRelationshipWithBaby(babyId: Int, relationshipType: String)
        async -> Result<BaseResponse<EmptyData>, RequestError
    >
    func postSetTeethStatus(babyId: Int,
                            teethId: Int,
                            date: String,
                            deletion: Bool
                            
    ) async -> Result<
        BaseResponse<EmptyData>, RequestError
    >
    func getGetGrowthData(babyId: Int
    )
    async -> Result<BaseResponse<GetGrowthDataResModel>, RequestError
    >
}

class BabyMoaService: BabyMoaServicable {
    func getGetGrowthData(babyId: Int) async -> Result<BaseResponse<GetGrowthDataResModel>, RequestError> {
        let result = await request(
            endpoint: BabyMoaEndpoint.getGrowthData(babyId: babyId),
            responseModel: BaseResponse<GetGrowthDataResModel>.self
        )
        switch result {
        case .success:
            return result
        case .failure(let error):
            switch error {
            case .unauthorized :
                return await
                self.getGetGrowthData(babyId: babyId)
            default:
                return result
            }
        }
    }
    func postSetTeethStatus(
        babyId: Int, teethId: Int, date: String, deletion: Bool
    ) async ->
    Result<BaseResponse<EmptyData>,
            RequestError> {
        let result = await request(
            endpoint:
                BabyMoaEndpoint.setTeethStatus(babyId: babyId, teethId: teethId, date: date, deletion: deletion),
            responseModel: BaseResponse<EmptyData>.self
            )
                switch result {
                case .success:
                    return result
                case .failure(let error):
                    switch error {
                    case .unauthorized :
                        return await
                        self.postSetTeethStatus(babyId: babyId, teethId: teethId, date: date, deletion: deletion)
                    default:
                        return result
                    }
                }
    }
    
    func postSetRelationshipWithBaby(
        babyId: Int, relationshipType: String
    ) async ->
    Result<BaseResponse<EmptyData>,
           RequestError> {
               let result = await request(
                endpoint: BabyMoaEndpoint.setRelationshipWithBaby(babyId: babyId, relationshipType: relationshipType),
                responseModel:
                    BaseResponse<EmptyData>.self
               )
               switch result {
               case .success:
                   return result
               case .failure(let error):
                   switch error {
                   case .unauthorized :
                       return await self.postSetRelationshipWithBaby(babyId: babyId, relationshipType: relationshipType)
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
                // refresh api 호출 -> access, refresh 토큰 발급할 거에요 -> 로컬에 저장해주시면 되고,

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

}
