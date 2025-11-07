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

@MainActor
class BabyMainViewModel: ObservableObject {
    
    @Published var babies : [Babies] = []
    @Published var selectedBaby: Babies?
    @Published var isShowingSheet: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSignOutAlert: Bool = false
    
    @Published var coordinator: BabyMoaCoordinator

    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
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
    
    func fetchBabies() async {
        isLoading = true
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
            
            let fetchedBabies = Babies.mockBabies
            self.babies = fetchedBabies
            self.selectedBaby = fetchedBabies.first
            self.errorMessage = nil
            
        } catch {
            print("아기 데이터를 가져오는데 실패했습니다 \(error.localizedDescription)")
            
        }
        
        isLoading = false
    }
    
    func selectBaby(_ baby: Babies) {
        self.selectedBaby = baby
        self.isShowingSheet = false
    }
    
    func showBabyListSheet(){
        isShowingSheet  = true
    }
}
