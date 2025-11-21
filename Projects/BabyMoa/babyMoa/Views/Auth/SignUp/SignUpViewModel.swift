//
//  SignUpViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import AuthenticationServices
import SwiftUI

@Observable
final class SignUpViewModel {
    var coordinator: BabyMoaCoordinator
    var termCheckList: [TermCheckItem]
    var isShowingPrivacySheet = false
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        self.termCheckList = []
        self.termCheckList = [
            TermCheckItem(
                term: Term.ageRestriction,
                isChecked: false
            ),
            TermCheckItem(
                term: Term.privacyConsent,
                isChecked: false,
                moreAction: { [weak self] in
                    self?.isShowingPrivacySheet = true
                }
            )
        ]
    }
    
    func isAllChecked() -> Bool {
        for termCheck in termCheckList {
            if !termCheck.isChecked {
                return false
            }
        }
        return true
    }
    
    func handleRequest(request: ASAuthorizationAppleIDRequest) {
        // 요청할 정보 설정
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleCompletion(result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                if let identityTokenData = appleIDCredential.identityToken,
                   let token = String(data: identityTokenData, encoding: .utf8) {
                    let result = await BabyMoaService.shared.postAppleLogin(idToken: token)
                    switch result {
                    case .success(let success):
                        guard let resModel = success.data else {
                            return
                        }
                        let tokenResult = await resModel.toDomain()
                        
                        // 1. UserToken의 정적 변수에 토큰을 할당합니다.
                        //    (@UserDefault 래퍼를 통해 UserDefaults에도 자동으로 저장됩니다.)
                        UserToken.accessToken = tokenResult.accessToken
                        UserToken.refreshToken = tokenResult.refreshToken
                        
                        await MainActor.run {
                            // 2. 앱의 전역 상태를 '로그인 됨'으로 변경하여 UI를 업데이트합니다.
                            AppState.shared.sessionState = .signedIn
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        case .failure(let error):
            print("❌ Apple Sign in failed: \(error.localizedDescription)")
        }
    }
}

enum Term: CaseIterable {
    case ageRestriction
    case privacyConsent
    
    var termString: String {
        switch self {
        case .ageRestriction:
            return "만 14세 이상"
        case .privacyConsent:
            return "개인정보 수집 및 이용 동의"
        }
    }
}

struct TermCheckItem {
    var term: Term
    var isChecked: Bool
    var moreAction: (() -> Void)?
}
