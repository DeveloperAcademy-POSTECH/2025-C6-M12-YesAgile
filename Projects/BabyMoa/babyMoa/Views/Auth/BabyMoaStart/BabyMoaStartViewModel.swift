//
//  BabyMoaStartViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

@Observable
class BabyMoaStartViewModel {
    var coordinator: BabyMoaCoordinator
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
    }
    
    func temporaryLoginButtonTapped() async {
        let result = await BabyMoaService.shared.postAppleLogin(idToken: JWTUtil.shared.generateTestJWT())
        switch result {
        case .success(let success):
            guard let tokenRes = success.data else { return }
            TokenManager.shared.saveAccessToken(tokenRes.accessToken)
            TokenManager.shared.saveRefreshToken(tokenRes.refreshToken)
            UserToken.accessToken = tokenRes.accessToken
            UserToken.refreshToken = tokenRes.refreshToken
            await MainActor.run {
                // 2. 앱의 전역 상태를 '로그인 됨'으로 변경하여 UI를 업데이트합니다.
                AppState.shared.sessionState = .signedIn
            }
        case .failure(let error):
            print(error)
        }
    }
}
