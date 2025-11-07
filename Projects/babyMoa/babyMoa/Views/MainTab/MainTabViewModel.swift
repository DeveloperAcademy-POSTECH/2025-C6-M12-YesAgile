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
    // refreshToken이 만료되면 강제 로그아웃이 되게 구성되어 있다.
    // 그것에 RootViewModel에서 정의되어 있으니 RootViewModel에서 초기화 부탁
    
    private let LAST_BABY_ID_KEY = "lastSelectedBabyID"
    
    // var selectedBaby: Babies? // 이제 MainTabModel을 사용합니다.
    
    /// UI에 표시될 선택된 아기 요약 정보입니다.
    var selectedBaby: MainTabModel?
    
    /// UI에 표시될 전체 아기 목록 요약 정보입니다.
    var babies: [MainTabModel] = []
    var isShowingSheet = false
    
    var coordinator: BabyMoaCoordinator
    private let babyMoaService: BabyMoaServicable
    
    let babyMainViewModel: BabyMainViewModel
    let growthViewModel: GrowthViewModel
    
    init(coordinator: BabyMoaCoordinator, babyMoaService: BabyMoaServicable = BabyMoaService.shared) {
        self.coordinator = coordinator
        self.babyMoaService = babyMoaService
        
        self.babyMainViewModel = BabyMainViewModel(coordinator: coordinator)
        self.growthViewModel = GrowthViewModel(coordinator: coordinator)
        
        Task {
            await fetchBabies()
        }
    }
    
    //    func fetchBabies() {
    //        // Simulate network request
    //        self.babies = Babies.mockBabies
    //        if self.selectedBaby == nil {
    //            self.selectedBaby = babies.first
    //        }
    //    }
    
    // 서버에서 아기 목록 요약 정보를 가져와서 UI를 업데이트합니다.
    func fetchBabies() async {
        let result = await babyMoaService.getGetBabyList()

        switch result {
        case .success(let response):
            // `BabyMoaRootViewModel`에서 이미 아기 목록이 있음을 확인했으므로,
            // 여기서는 데이터를 UI 모델로 변환하고 상태를 업데이트하는 데 집중합니다.
            if let babyList = response.data, !babyList.isEmpty {
                // API 응답을 UI 모델(`MainTabModel`)로 변환합니다.
                self.babies = babyList.map { babyData in
                    return MainTabModel(
                        id: babyData.id,
                        name: babyData.name,
                        profileImageUrl: babyData.profileImageUrl
                    )
                }

                // --- 마지막으로 선택한 아기를 복원하는 로직 ---
                let savedBabyID = UserDefaults.standard.integer(forKey: LAST_BABY_ID_KEY)
                
                var babyToSelect: MainTabModel? = nil
                
                if savedBabyID != 0 {
                    babyToSelect = self.babies.first { $0.id == savedBabyID }
                }
                
                if let foundBaby = babyToSelect {
                    self.selectedBaby = foundBaby
                } else {
                    self.selectedBaby = babies.first
                    if let firstBaby = babies.first {
                        UserDefaults.standard.set(firstBaby.id, forKey: LAST_BABY_ID_KEY)
                    }
                }
                // --- 로직 끝 ---
            } else {
                // RootViewModel에서 분기 처리를 했으므로, 이 경우는 거의 발생하지 않아야 합니다.
                // 만약을 위해 로컬 목록을 비웁니다.
                self.babies = []
            }

        case .failure(let error):
            // 네비게이션 로직은 RootViewModel로 이동했으므로 여기서는 에러만 기록합니다.
            print("MainTabViewModel - 아기 목록을 가져오는데 실패했습니다: \(error.localizedDescription)")
            self.babies = []
        }
    }
    
    /// 사용자가 목록에서 아기를 선택했을 때 호출됩니다.
    func selectBaby(_ baby: MainTabModel) {
        // 1. UI에 표시될 아기 요약 정보를 업데이트합니다.
        self.selectedBaby = baby
        self.isShowingSheet = false
        
        // 2. 선택된 아기 ID를 UserDefaults에 저장합니다.
        UserDefaults.standard.set(baby.id, forKey: LAST_BABY_ID_KEY)
    }
    
    func showBabyListSheet() {
        self.isShowingSheet = true
    }
}
