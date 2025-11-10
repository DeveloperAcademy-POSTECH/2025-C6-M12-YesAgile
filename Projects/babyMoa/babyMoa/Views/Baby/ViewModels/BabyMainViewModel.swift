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
    
    func signOut() -> Bool {
        do {
            
            // SignOut 함수를 만들어야 한다.
            // 어떻게 해야 되는지 서버와 이야기 해야 한다.
            
            return true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            return false
        }
    }
}
