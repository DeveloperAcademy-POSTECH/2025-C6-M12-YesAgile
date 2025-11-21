//
//  BabyMoaRoot.swift
//  babyMoa
//
//  Created by 한건희 on 11/1/25.
//

import SwiftUI

struct BabyMoaRootView: View {
    @StateObject private var coordinator = BabyMoaCoordinator()
    @StateObject private var appState = AppState.shared
    @StateObject private var alertManager = AlertManager()
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            Group {
                switch appState.sessionState {
                case .signedIn:
                    // 로그인 상태일 경우, AuthenticatedRootView를 통해 실제 메인 화면 또는 아기 추가 화면으로 분기
                    AuthenticatedRootView(coordinator: coordinator)
                case .signedOut:
                    // 로그아웃 상태일 경우, BabyMoaStartView를 루트 뷰로 설정
                    BabyMoaStartView(coordinator: coordinator)
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
                case .allMilestones:
                    AllMilestoneView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .teeth(let teethList):
                    TeethView(
                        coordinator: coordinator,
                        teethList: teethList
                    )
                    .navigationBarBackButtonHidden()

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
                    BabyMainView(viewModel: BabyMainViewModel(coordinator: coordinator), coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .guardain:
                    GuardianInvitationView(viewModel: GuardianInvitationCodeViewModel(coordinator: coordinator))
                        .navigationBarBackButtonHidden()
                case .guardiainCode(let viewModel):
                    GuardianCodeView(viewModel: viewModel)
                        .navigationBarBackButtonHidden()
                    
                    // New Weight and Height View
                case .newHeight(let babyId):
                    HeightView(coordinator: coordinator, babyId: babyId)
                        .navigationBarBackButtonHidden()
                    
                case .newHeightAdd(let babyId):
                    HeightAddView(coordinator: coordinator, babyId: babyId)
                        .navigationBarBackButtonHidden()
                    
                case .newWeight(let babyId):
                    WeightView(coordinator: coordinator, babyId: babyId)
                        .navigationBarBackButtonHidden()
                    
                case .newWeightAdd(let babyId):
                    WeightAddView(coordinator: coordinator, babyId: babyId)
                        .navigationBarBackButtonHidden()
                    
                case .accountDeleteConfirmView:
                        AccountDeleteConfirmView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                default:
                    EmptyView()
                }
            }
        }
        .environmentObject(alertManager)
        .alert(alertManager.alertTitle, isPresented: $alertManager.showAlert) {
            Button("확인") { }
        } message: {
            Text(alertManager.alertMessage)
        }
        .onChange(of: appState.sessionState) { _, newState in
            // 세션 상태가 로그아웃으로 변경되면, 네비게이션 스택을 모두 비워
            // 깨끗한 상태에서 로그인/온보딩 플로우를 시작하도록 합니다.
            if newState == .signedOut {
                coordinator.paths.removeAll()
            }
        }
    }
}
