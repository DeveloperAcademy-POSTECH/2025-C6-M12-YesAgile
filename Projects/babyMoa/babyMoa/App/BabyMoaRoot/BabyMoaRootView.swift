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
    @StateObject var alertManager = AlertManager()
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            // isReady 상태에 따라 로딩 뷰 또는 컨텐츠 뷰를 표시
            Group {
                if viewModel.isReady {
                    VStack {
                        // 초기 경로 설정이 완료된 후의 뷰 (현재는 비어 있음)
                    }
                    .navigationBarBackButtonHidden()
                } else {
                    // 앱 시작 시 데이터를 로드하는 동안 표시될 로딩 뷰
                    ProgressView()
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
                    JourneyView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
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
                    BabyMainView(viewModel: BabyMainViewModel(coordinator: coordinator), coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .guardain:
                    GuardianInvitationView(viewModel: GuardianInvitationCodeViewModel(coordinator: coordinator))
                        .navigationBarBackButtonHidden()
                case .guardiainCode(let viewModel):
                    GuardianCodeView(viewModel: viewModel)
                        .navigationBarBackButtonHidden()
                case .journeyList(let date, let journies):
                    JourneyListView(coordinator: coordinator,
                                    selectedDate: date,
                                    journies: journies)
                                    .navigationBarBackButtonHidden()
                case .journeyAdd(let date):
                    JourneyAddView(coordinator: coordinator,
                                   selectedDate: date,
                                   onSave: { image, memo in //Todo : -onSave 어떻게 받을지 고민해보기. 옮겨야할
                                        }
                                    )
                                    .navigationBarBackButtonHidden()

                }
            }
        }
        .onAppear {
            // 뷰가 처음 나타날 때 초기 화면 경로를 결정하는 로직을 실행
            if coordinator.paths.isEmpty {
                Task {
                    await viewModel.checkInitialScreen(coordinator: coordinator)
                }
            }
        }
        .onChange(of: coordinator.paths) { _, newValue in
            // 로그인 성공 등으로 네비게이션 스택이 리셋되면(newValue.isEmpty) 초기 화면을 다시 결정합니다.
            if newValue.isEmpty {
                viewModel.isReady = false // 로딩 뷰를 다시 표시
                Task {
                    await viewModel.checkInitialScreen(coordinator: coordinator)
                }
            }
        }
        //MARK: - 경고창에 대해 사용하도로 해야 한다.
        .environmentObject(alertManager)
        .alert(alertManager.alertTitle, isPresented: $alertManager.showAlert) {
            Button("확인") { }
        } message: {
            Text(alertManager.alertMessage)
        }
    }
}
