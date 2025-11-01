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
}

class BabyMoaService: BabyMoaServicable {
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
