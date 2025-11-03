//
//  BabyMoaRoot.swift
//  babyMoa
//
//  Created by 한건희 on 11/1/25.
//

import SwiftUI

struct BabyMoaRootView: View {
    @StateObject var coordinator = BabyMoaCoordinator()
    @StateObject var viewModel = BabyMoaRootViewModel()
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            VStack {
                
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                if viewModel.isUserAuthorized() {
                    coordinator.push(path: .mainTab)
                } else {
                    coordinator.push(path: .startBabyMoa)
                }
            }
            .navigationDestination(for: CoordinatorPath.self) { path in
                switch path {
                case .startBabyMoa:
                    BabyMoaStartView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .login:
                    SignUpView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .mainTab:
                    MainTabView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .growth:
                    GrowthView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .journey:
                    EmptyView()
                case .privacyConsent:
                    PrivacyConsentView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .allMilestones(let allMilestones):
                    EmptyView()
                case .height:
                    EmptyView()
                case .weight:
                    EmptyView()
                case .teeth(let teethList):
                    TeethView(
                        coordinator: coordinator,
                        teethList: teethList
                    )
                }
            }
        }
    }
}
