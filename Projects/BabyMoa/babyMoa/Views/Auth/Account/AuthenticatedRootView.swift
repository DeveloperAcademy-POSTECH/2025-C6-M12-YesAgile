//
//  AuthenticatedRootView.swift
//  babyMoa
//
//  Created by Baba on 11/21/25.
//
//  이 뷰는 인증된 사용자를 위한 초기 라우터 역할을 합니다.
//  사용자가 등록한 아기가 있는지 확인하고, 그 결과에 따라
//  적절한 메인 화면(MainTabView 또는 AddBabyView)으로 네비게이션합니다.
//

import SwiftUI

struct AuthenticatedRootView: View {
    let coordinator: BabyMoaCoordinator
    
    // nil: 로딩 중, true: 아기 있음, false: 아기 없음
    @State private var hasBabies: Bool? = nil
    
    var body: some View {
        Group {
            if let hasBabies = hasBabies {
                if hasBabies {
                    // 아기가 등록되어 있으면 메인 탭 화면으로 이동
                    MainTabView(coordinator: coordinator)
                } else {
                    // 아기가 등록되어 있지 않으면 아기 추가 화면으로 이동
                    AddBabyView(coordinator: coordinator)
                }
            } else {
                // 아기 정보 확인 중(nil)일 때 로딩 인디케이터 표시
                ProgressView("아기 정보 확인 중...")
            }
        }
        .task {
            // 뷰가 나타날 때 한 번 실행되어 아기 목록을 확인합니다.
            // Repository의 캐시 덕분에 두 번째 진입부터는 로딩 없이 즉시 실행됩니다.
            let babies = await BabyRepository.shared.fetchBabyList()
            self.hasBabies = !babies.isEmpty // 아기 목록 유무에 따라 상태 설정
        }
    }
}
