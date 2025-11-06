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
                coordinator.push(path: .babyMain)
//                if viewModel.isUserAuthorized() {
//                    coordinator.push(path: .mainTab)
//                } else {
//                    coordinator.push(path: .startBabyMoa)
//                }
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
                    AllMilestoneView(coordinator: coordinator, allMilestones: allMilestones)
                case .height(let babyId):
                    GrowthDetailView<Height>(
                        coordinator: coordinator,
                        growthDetailType: .height,
                        babyId: babyId
                    )
                case .weight(let babyId):
                    GrowthDetailView<Weight>(
                        coordinator: coordinator,
                        growthDetailType: .weight,
                        babyId: babyId
                    )
                case .teeth(let teethList):
                    TeethView(
                        coordinator: coordinator,
                        teethList: teethList
                    )
                    // Add Baby and Guardian - 라우팅 잘 되어야 한다.
                case .addBaby:
                    AddBabyView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .addBabyCreate:
                    AddBabyCreate(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .addBabyInvitaion:
                    AddBabyInvitationView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .addBabyStatus(let baby, let isBorn):
                    AddBabyStatusView(coordinator: coordinator, baby: baby, isBorn: isBorn)
                        .navigationBarBackButtonHidden()
                    // BabyMainView - 라우팅이 잘 되어야 한다.
                case .babyMain:
                    BabyMainView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .guardain:
                    GuardianInvitationView(viewModel: GuardianInvitationCodeViewModel())
                        .navigationBarBackButtonHidden()
                case .guardiainCode:
                    GuardianCodeView(viewModel: GuardianInvitationCodeViewModel())
                        .navigationBarBackButtonHidden()

                }
            }
        }
    }
}
