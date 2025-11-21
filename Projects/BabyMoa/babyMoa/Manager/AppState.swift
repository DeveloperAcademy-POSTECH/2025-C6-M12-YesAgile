//
//  AppState.swift
//  babyMoa
//
//  Created by Baba on 11/21/25.
//
//  앱의 최상위 상태를 관리하는 중앙 저장소 역할을 합니다.
//  UI는 이 상태의 변화를 감지하여 화면을 업데이트합니다.
//

import Foundation
import Combine

/// 앱의 현재 세션 상태를 나타냅니다.
enum SessionState {
    /// 로그인되지 않은 상태. 온보딩/로그인 플로우를 보여줍니다.
    case signedOut
    
    /// 로그인된 상태. 메인 앱 컨텐츠를 보여줍니다.
    case signedIn
}

/// 앱의 전역 상태를 관리하는 ObservableObject 클래스입니다.
/// 이 클래스는 싱글톤으로 사용되어 앱의 어떤 곳에서든 동일한 인스턴스에 접근할 수 있습니다.
final class AppState: ObservableObject {
    /// AppState의 공유 인스턴스.
    static let shared = AppState()
    
    /// 현재 세션 상태를 Published 프로퍼티로 선언하여, SwiftUI 뷰가 이 값의 변경을 감지하고 자동으로 UI를 업데이트할 수 있도록 합니다.
    @Published var sessionState: SessionState
    
    private init() {
        // 앱 시작 시, 토큰 존재 여부에 따라 초기 세션 상태를 결정합니다.
        // 토큰이 있으면 signedIn, 없으면 signedOut 상태로 시작합니다.
        if TokenManager.shared.loadAccessToken() != nil {
            self.sessionState = .signedIn
        } else {
            self.sessionState = .signedOut
        }
    }
}
