//
//  MainTabViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI
import Foundation

@MainActor // 메인에서 작업을 해야 데이터를 불러오고 나서 사용할 수 있다고 생각??? 하는데 .... 
@Observable
final class MainTabViewModel {
    
    // Storage에 사용할 고유키 LAST_BABY_ID_KEY 로 저장한다.
    // 앱을 다시 시작했을때, 마지막으로 선택한 이기를 유지해야 한다.
    // 단, refresh Token이 만료되면, 즉, 400 에러를 받으면 삭제를 한다.
    // 삭제는 BabyMoaService에서 진행한다.
    private let LAST_BABY_ID_KEY = "lastSelectedBabyID"
    
    var selectedBaby: Babies?
    var babies: [Babies] = []
    var isShowingSheet = false
    
    var coordinator: BabyMoaCoordinator
    
    let babyMainViewModel: BabyMainViewModel
    let growthViewModel: GrowthViewModel
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        
        self.babyMainViewModel = BabyMainViewModel(coordinator: coordinator)
        self.growthViewModel = GrowthViewModel(coordinator: coordinator)
        
        fetchBabies()
    }
    
    func fetchBabies() {
        // Simulate network request
        self.babies = Babies.mockBabies
        if self.selectedBaby == nil {
            self.selectedBaby = babies.first
        }
    }
    
    func selectBaby(_ baby: Babies) {
        self.selectedBaby = baby
        self.isShowingSheet = false
    }
    
    func showBabyListSheet() {
        self.isShowingSheet = true
    }
}
