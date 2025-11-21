//
//  BabyRepository.swift
//  babyMoa
//
//  Created by Baba on 11/21/25.
//
//  이 리포지토리는 아기 목록 데이터에 대한 단일 진실 공급원(Single Source of Truth) 역할을 합니다.
//  네트워크에서 데이터를 가져와 메모리에 캐싱함으로써,
//  서로 다른 ViewModel에서 중복된 요청이 발생하는 것을 방지합니다.
//

import Foundation

final class BabyRepository {
    static let shared = BabyRepository()
    
    private var babyListCache: [MainTabModel] = []
    
    private init() {}
    
    /// 아기 목록을 가져옵니다.
    /// 메모리 캐시된 목록이 있다면 반환하고, 그렇지 않으면 네트워크에서 가져옵니다.
    func fetchBabyList() async -> [MainTabModel] {
        // 1. 이미 채워진 캐시 데이터가 있다면 반환합니다.
        if !babyListCache.isEmpty {
            print("✅ [BabyRepository] Returning cached baby list.")
            return babyListCache
        }
        
        print("🟡 [BabyRepository] No cached data. Fetching from server.")
        
        // 2. 네트워크에서 데이터를 가져옵니다.
        let result = await BabyMoaService.shared.getGetBabyList()

        switch result {
        case .success(let response):
            guard let babyListData = response.data, !babyListData.isEmpty else {
                print("ℹ️ [BabyRepository] Fetched list is empty.")
                self.babyListCache = []
                return []
            }
            
            // 3. 응답 데이터를 UI 모델로 매핑합니다.
            let babies = babyListData.map { babyData in
                return MainTabModel(
                    id: babyData.id,
                    name: babyData.name,
                    profileImageUrl: babyData.profileImageUrl
                )
            }
            
            // 4. 새로 가져온 목록을 캐시하고 반환합니다.
            print("✅ [BabyRepository] Fetched and cached \(babies.count) babies.")
            self.babyListCache = babies
            return babies

        case .failure(let error):
            print("🔴 [BabyRepository] Failed to fetch baby list: \(error.localizedDescription)")
            // 실패 시, 캐시를 확실히 비우고 빈 목록을 반환합니다.
            self.babyListCache = []
            return []
        }
    }
    
    /// 아기 목록에 대한 메모리 캐시를 무효화합니다.
    /// 목록이 변경되거나(예: 아기 추가/삭제) 로그아웃 시 호출해야 합니다.
    func clearCache() {
        print("ℹ️ [BabyRepository] Clearing baby list cache.")
        babyListCache = []
    }
}
