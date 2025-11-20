//
//  BabyMoaRootViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/1/25.
//

import SwiftUI

@MainActor

//final class BabyMoaRootViewModel: ObservableObject {
//    func isUserAuthorized() -> Bool {
//        if UserToken.accessToken == "" {
//            return false
//        }
//        return true
//    }
//}


final class BabyMoaRootViewModel: ObservableObject {
    /// 앱 로딩 및 초기 경로 설정이 완료되었는지 여부를 나타냅니다.
    @Published var isReady = false
    
    private let babyMoaService: BabyMoaServicable
    
    init(babyMoaService: BabyMoaServicable = BabyMoaService.shared) {
        self.babyMoaService = babyMoaService
    }
    
    /// 앱 시작 시 사용자의 상태(로그인, 아기 등록 여부)를 확인하여 초기 화면 경로를 결정합니다.
    func checkInitialScreen(coordinator: BabyMoaCoordinator) async {
        // 1. 사용자 로그인 상태 확인
        guard UserToken.accessToken != "" else {
            // 로그인 되어 있지 않으면 시작 화면으로 이동
            coordinator.push(path: .startBabyMoa)
            isReady = true
            return
        }
        
        // 2. 등록된 아기 목록 확인
        let result = await babyMoaService.getGetBabyList()
        switch result {
        case .success(let response):
            if let babyList = response.data, !babyList.isEmpty {
                // 아기 목록이 있으면 메인 탭 화면으로 이동
                coordinator.push(path: .mainTab)
            } else {
                // 아기 목록이 없으면 아기 추가 화면으로 이동
                coordinator.push(path: .addBaby)
            }
        case .failure:
            // API 요청 실패 시에도 아기 추가 화면으로 이동 (오류 처리)
            coordinator.push(path: .addBaby)
        }
        
        // 3. 모든 확인 절차가 끝나면 isReady를 true로 설정하여 화면을 표시
        isReady = true
    }
}
