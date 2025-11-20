//
//  BabyMoaStartViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

@Observable
class BabyMoaStartViewModel {
    var coordinator: BabyMoaCoordinator
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
    }
}
