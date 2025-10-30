//
//  BabyMoaService.swift
//  babyMoa
//
//  Created by 한건희 on 10/30/25.
//

protocol BabyMoaServicable: HTTPClient {
    func postAppleLogin(idToken: String) async -> Result<BaseResponse<AppleLoginResModel>, RequestError>
}

class BabyMoaService: BabyMoaServicable {
    public static let shared = BabyMoaService()
    
    private init() { }
    
    func postAppleLogin(idToken: String) async -> Result<BaseResponse<AppleLoginResModel>, RequestError> {
        return await request(endpoint: BabyMoaEndpoint.appleLogin(idToken: idToken), responseModel: BaseResponse<AppleLoginResModel>.self)
    }
    
    
}
