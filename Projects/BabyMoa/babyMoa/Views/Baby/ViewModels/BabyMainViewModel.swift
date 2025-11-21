//
//  BabyMainViewModel.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//
//  Babay관련 비즈니스 로직과 상태 관리를 담당하는 BabyMainViewModel입니다.
//  여기서 분리를 해야 되는 것이 있는데 그것은 아기의 정보를 받아오는 것이다. 즉, MainTabViewModel에서 아기 정보를 받아오는 것이 맞다.
//  BabyMainViewModel은 아기 정보를 받아온 후, 선택된 아기의 상태 관리와 관련된 로직을 담당합니다.

import Foundation
import Combine

@MainActor
class BabyMainViewModel: ObservableObject {
    
    /// 현재 화면에 표시될 아기의 상세 정보입니다.
    @Published var selectedBaby: Babies?
    
    @Published var showSignOutAlert: Bool = false
    @Published var coordinator: BabyMoaCoordinator

    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        
        // 공유 상태 객체인 SelectedBabyState.shared의 baby 프로퍼티 변경을 구독합니다.
        SelectedBabyState.shared.$baby
            .receive(on: DispatchQueue.main) // UI 업데이트는 메인 스레드에서 수행합니다.
            .sink { [weak self] newBaby in
                // 공유된 아기 정보가 변경되면, 이 뷰모델의 selectedBaby를 업데이트합니다.
                self?.selectedBaby = newBaby
                print("BabyMainViewModel: Received updated baby - \(newBaby?.name ?? "nil")")
            }
            .store(in: &cancellables)
    }
    
    func signOut() {
        // 중앙 세션 관리자를 통해 안전하게 로그아웃을 처리합니다.
        // 이 함수 하나로 토큰 삭제, 캐시 클리어, 화면 상태 변경이 모두 이루어집니다.
        SessionManager.signOut()
    }
}
