//
//  SignUpViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//
import AuthenticationServices
import SwiftUI

final class SignUpViewModel: ObservableObject {
    @ObservedObject var coordinator: BabyMoaCoordinator
    @Published var termCheckList: [TermCheckItem]
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        termCheckList = [
            TermCheckItem(
                term: Term.ageRestriction,
                isChecked: false
            ),
            TermCheckItem(
                term: Term.privacyConsent,
                isChecked: false,
                moreAction: {
                    coordinator.push(path: .privacyConsent)
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
                        UserToken.accessToken = resModel.accessToken
                        UserToken.refreshToken = resModel.refreshToken
                        coordinator.push(path: .growth)
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
