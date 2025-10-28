//
//  AppState.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//

import SwiftUI
import AuthenticationServices

@Observable
final class AppState {
    var selectedTab: TabType = .home
    var isAuthenticated: Bool = false
    var hasRegisteredBaby: Bool = false
    var currentUser: User?
    
    enum TabType: String, CaseIterable {
        case home = "house.fill"
        case memory = "photo.on.rectangle.angled"
        case settings = "gearshape.fill"
        
        var title: String {
            switch self {
            case .home: return "홈"
            case .memory: return "추억"
            case .settings: return "설정"
            }
        }
    }
    
    // MARK: - Authentication Methods
    
    func signIn(with authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("❌ Failed to get Apple ID credential")
            return
        }
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            print("❌ Failed to get identity token")
            return
        }
        
        let user = User(
            id: appleIDCredential.user,
            name: appleIDCredential.fullName?.givenName,
            email: appleIDCredential.email
        )
        
        currentUser = user
        isAuthenticated = true
        
        // 사용자 ID 저장
        KeyChainHelper.save(key: "userId", value: user.id)
        
        // AccessToken 저장 (TokenManager 사용)
        // Apple Sign In에서 받은 identityToken을 AccessToken으로 사용
        TokenManager.shared.saveAccessToken(identityToken)
        
        // TODO: 백엔드에서 RefreshToken도 받으면 저장
        // TokenManager.shared.saveRefreshToken(refreshToken)
        
        print("✅ Successfully signed in: \(user.id)")
    }
    
    func signUp(with authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("❌ Failed to get Apple ID credential")
            return
        }
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            print("❌ Failed to get identity token")
            return
        }
        
        let user = User(
            id: appleIDCredential.user,
            name: appleIDCredential.fullName?.givenName,
            email: appleIDCredential.email
        )
        
        currentUser = user
        isAuthenticated = true
        hasRegisteredBaby = false
        
        // 사용자 ID 저장
        KeyChainHelper.save(key: "userId", value: user.id)
        
        // AccessToken 저장 (TokenManager 사용)
        TokenManager.shared.saveAccessToken(identityToken)
        
        // TODO: 백엔드에서 RefreshToken도 받으면 저장
        // TokenManager.shared.saveRefreshToken(refreshToken)
        
        print("✅ Successfully signed up: \(user.id)")
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        hasRegisteredBaby = false
        
        // 사용자 ID 삭제
        KeyChainHelper.delete(key: "userId")
        
        // TokenManager를 통해 모든 토큰 삭제
        TokenManager.shared.clearAllTokens()
        
        print("✅ Successfully signed out")
    }
    
    func checkSession() {
        // 사용자 ID와 AccessToken이 모두 있으면 세션 복원
        if let userId = KeyChainHelper.load(key: "userId"),
           let _ = TokenManager.shared.loadAccessToken() {
            
            currentUser = User(id: userId, name: nil, email: nil)
            isAuthenticated = true
            hasRegisteredBaby = true
            
            print("✅ Session restored for user: \(userId)")
        } else {
            print("ℹ️ No saved session found")
        }
    }
    
    func registerBaby() {
        hasRegisteredBaby = true
        print("✅ Baby registered")
    }
}

struct User: Identifiable {
    let id: String
    var name: String?
    var email: String?
}

