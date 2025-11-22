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
    
    // MainTabViewModel은 더 이상 하위 뷰모델을 직접 알 필요가 없습니다.
    // let babyMainViewModel: BabyMainViewModel
    // let growthViewModel: GrowthViewModel
    
    init(coordinator: BabyMoaCoordinator, babyMoaService: BabyMoaServicable = BabyMoaService.shared) {
        self.coordinator = coordinator
        self.babyMoaService = babyMoaService
        
        // self.babyMainViewModel = BabyMainViewModel(coordinator: coordinator)
        // self.growthViewModel = GrowthViewModel(coordinator: coordinator)
        
        Task {
            await fetchBabies()
        }
    }
    
    // 서버에서 아기 목록 요약 정보를 가져와서 UI를 업데이트합니다. (BabyRepository 사용)
    func fetchBabies() async {
        let babies = await BabyRepository.shared.fetchBabyList(isBabyAdded: coordinator.isBabyAdded) // BabyRepository에서 아기 목록을 가져옴

        // 디버깅 로그: Repository에서 가져온 아기 목록을 출력합니다.
        print("✅ 아기 목록 가져옴 (Repository): \(babies)")
            
        if !babies.isEmpty {
            // BabyRepository가 이미 MainTabModel 형태로 데이터를 제공하므로, 추가 변환 불필요.
            self.babies = babies

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
            
            // 공유 상태 업데이트: 앱 시작 시 선택된 아기의 상세 정보를 가져와 공유합니다.
            if let selectedBaby = self.selectedBaby {
                Task {
                    await fetchAndSetSharedBaby(id: selectedBaby.id)
                }
            }
            
        } else {
            // Repository에서도 아기 목록이 비어있음.
            // (AuthenticatedRootView에서 이미 이 경우 AddBabyView로 보냈을 것이므로,
            // MainTabView는 사실상 이 경로로 들어오지 않습니다. 여기서는 방어적인 코드입니다.)
            self.babies = []
            print("ℹ️ MainTabViewModel - Repository에서도 아기 목록이 비어있습니다.")
        }
    }
    
    /// 사용자가 목록에서 아기를 선택했을 때 호출됩니다.
    func selectBaby(_ baby: MainTabModel) {
        // 1. UI에 표시될 아기 요약 정보를 업데이트합니다.
        self.selectedBaby = baby
        self.isShowingSheet = false
        
        // 2. 선택된 아기 ID를 UserDefaults에 저장합니다.
        UserDefaults.standard.set(baby.id, forKey: LAST_BABY_ID_KEY)
        
        // 3. 공유 상태 업데이트: 선택된 아기의 상세 정보를 가져와 공유합니다.
        Task {
            await fetchAndSetSharedBaby(id: baby.id)
        }
    }
    
    /// 특정 아기의 전체 상세 정보를 서버에서 가져와 `SelectedBabyState` 공유 객체를 업데이트합니다.
    private func fetchAndSetSharedBaby(id: Int) async {
        let result = await babyMoaService.getBaby(babyId: id)
        switch result {
        case .success(let response):
            if let babyDetails = response.data {
                // `GetBabyResModel`을 `Babies` 모델로 변환합니다.
                let fullBabyObject = Babies(
                    babyId: babyDetails.id, // .babyId -> .id로 수정
                    alias: babyDetails.alias,
                    name: babyDetails.name,
                    birthDate: babyDetails.birthDate,
                    gender: babyDetails.gender,
                    avatarImageName: babyDetails.avatarImageName,
                    relationshipType: babyDetails.relationshipType
                )
                // 변환된 `Babies` 객체를 공유 상태에 업데이트합니다.
                SelectedBabyState.shared.baby = fullBabyObject
                print("✅ 공유 상태 업데이트 완료: \(fullBabyObject.name)")
            }
        case .failure(let error):
            print("❌ 아기 상세 정보를 가져오는데 실패했습니다: \(error)")
            SelectedBabyState.shared.baby = nil // 실패 시 공유 상태를 비웁니다.
        }
    }
    
    func showBabyListSheet() {
        self.isShowingSheet = true
    }
}
