//
//  SessionManager.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//
//  로그인, 로그아웃 등 세션과 관련된 전역 기능을 관리합니다.
//

import Foundation
import SwiftUI

final class SessionManager {
    
    /// 앱에서 로그아웃 또는 세션 종료가 필요할 때 호출하는 중앙 함수입니다.
    /// 모든 로컬 데이터와 캐시를 정리하고, 앱의 상태를 '로그아웃'으로 변경하여
    /// UI가 자동으로 로그인 화면으로 전환되도록 합니다.
    @MainActor
    static func signOut() {
        print("ℹ️ [SessionManager] Signing out and clearing all session data.")
        
        // 1. 기기에 저장된 모든 토큰 정보 삭제
        TokenManager.shared.clearAllTokens()
        
        // 2. 메모리에 캐싱된 마일스톤 데이터 삭제
        MilestoneRepository.shared.clearCache()
        
        // 3. 전역 앱 상태를 '로그아웃'으로 변경하여 UI가 반응하도록 함
        AppState.shared.sessionState = .signedOut
    }
}