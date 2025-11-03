//
//  GrowthViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

@Observable
final class GrowthViewModel {
    var coordinator: BabyMoaCoordinator
    
    // MARK: Properties
    var selectedBaby: BabySummary?
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
    }
    
    func getSelectedBabySummary() {
        if let selectedBabyId = SelectedBaby.babyId {
            
        }
    }
}
