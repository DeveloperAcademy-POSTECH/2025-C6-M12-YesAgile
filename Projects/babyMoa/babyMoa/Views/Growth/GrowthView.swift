//
//  GrowthView.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

struct GrowthView: View {
    @State var viewModel: GrowthViewModel
    
    init(coordinator: BabyMoaCoordinator) {
        viewModel = GrowthViewModel(coordinator: coordinator)
    }
    var body: some View {
        
    }
}
