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
                case .journeyList(let date, let journies): //0 다음 1번쨰 let date: enum에서 Date를 꺼냄 (상자에서 꺼내기)
                    //let journies: enum에서 [Journey] 배열을 꺼냄
                    //왜 필요?: 1단계에서 정의한 associated value를 사용하기 위해
                                    JourneyListView(
                                        coordinator: coordinator,
                                        selectedDate: date,
                                        journies: journies
                                    )
                                    .navigationBarBackButtonHidden()
                                
                                case .journeyAdd(let date):
                                    JourneyAddView(
                                        coordinator: coordinator,
                                        selectedDate: date,
                                        onSave: { image, memo in
                                            // Coordinator 경로: ViewModel 접근 불가 (print만)
                                            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
                                            print("✅ 여정 저장 요청 (Coordinator 경로)")
                                            print("  📅 날짜: \(date.formatted(date: .numeric, time: .omitted))")
                                            print("  📝 메모: \(memo.isEmpty ? "(없음)" : memo)")
                                            print("  📸 이미지: \(image != nil ? "있음" : "없음")")
                                            if let image = image {
                                                print("     크기: \(image.size.width) x \(image.size.height)")
                                            }
                                            print("  ⚠️ Mock 모드: 배열 추가 안 됨 (BabyMoaRootView는 JourneyViewModel 접근 불가)")
                                            print("  💡 나중에 API 연동 시:")
                                            print("     1. API POST 호출")
                                            print("     2. 성공 시 화면 pop()")
                                            print("     3. JourneyView.onAppear에서 다시 조회")
                                            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
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
