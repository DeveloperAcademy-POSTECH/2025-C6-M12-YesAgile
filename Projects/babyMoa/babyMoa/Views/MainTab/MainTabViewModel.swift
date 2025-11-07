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
