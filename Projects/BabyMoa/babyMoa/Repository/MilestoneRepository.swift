//
//  MilestoneRepository.swift
//  babyMoa
//
//  Created by Baba on 11/20/25.
//
//  이 리포지토리는 마일스톤 데이터에 대한 단일 진실 공급원(Single Source of Truth) 역할을 합니다.
//  네트워크에서 데이터를 가져와 메모리에 캐싱함으로써,
//  서로 다른 ViewModel에서 중복된 요청이 발생하는 것을 방지합니다.
//

import SwiftUI

final class MilestoneRepository {
    static let shared = MilestoneRepository()
    
    private var cachedBabyId: Int?
    private var allMilestones: [[GrowthMilestone]] = []
    
    private init() {}
    
    /// 주어진 아기 ID에 대한 모든 마일스톤을 가져옵니다.
    /// 동일한 아기에 대한 메모리 캐시 데이터가 있으면 반환하고,
    /// 그렇지 않으면 네트워크에서 가져옵니다.
    func fetchAllMilestones(babyId: Int) async -> [[GrowthMilestone]] {
        // 1. 동일한 아기에 대한 캐시된 데이터가 있고 비어 있지 않다면 캐시된 데이터를 반환합니다.
        if let cachedBabyId = self.cachedBabyId, cachedBabyId == babyId, !allMilestones.isEmpty {
            print("✅ [Repository] Returning cached milestones for babyId: \(babyId)")
            return allMilestones
        }
        
        print("🟡 [Repository] No cached data. Fetching from server for babyId: \(babyId)")
        
        // 2. 네트워크에서 데이터를 가져옵니다.
        let result = await BabyMoaService.shared.getGetBabyMilestones(babyId: babyId)
        
        switch result {
        case .success(let success):
            guard let milestonesData = success.data else {
                // 데이터가 없는 성공 응답인 경우, 캐시를 비우고 기본(mock) 데이터를 반환합니다.
                clearCache()
                return GrowthMilestone.mockData
            }
            
            var updatedMilestones = GrowthMilestone.mockData
            
            // 3. 데이터를 처리합니다 (이미지 동시 다운로드 포함).
            // 여러 이미지를 다운로드할 때는 TaskGroup을 사용하는 것이 성능상 더 효율적입니다.
            await withTaskGroup(of: (row: Int, col: Int, image: UIImage?).self) { group in
                for milestone in milestonesData {
                    // milestoneName 포맷(예: "milestone_0_1") 파싱
                    let row = Int(milestone.milestoneName.split(separator: "_")[1])!
                    let col = Int(milestone.milestoneName.split(separator: "_")[2])!
                    
                    // 이미지가 아닌 데이터(날짜, 설명 등)를 즉시 업데이트합니다.
                    if updatedMilestones.indices.contains(row) && updatedMilestones[row].indices.contains(col) {
                        updatedMilestones[row][col].completedDate = DateFormatter.yyyyDashMMDashdd.date(from: milestone.date)
                        updatedMilestones[row][col].description = milestone.memo
                        updatedMilestones[row][col].isCompleted = true
                    }
                    
                    // URL이 존재하면 이미지를 다운로드할 작업을 그룹에 추가합니다.
                    if let imageUrl = milestone.imageUrl, !imageUrl.isEmpty {
                        group.addTask {
                            // ImageManager의 캐싱 시스템을 자동으로 사용합니다.
                            let image = await ImageManager.shared.downloadImage(from: imageUrl)
                            return (row, col, image)
                        }
                    }
                }
                
                // 이미지 다운로드 작업이 완료되는 대로 결과를 수집하여 업데이트합니다.
                for await result in group {
                    if updatedMilestones.indices.contains(result.row) && updatedMilestones[result.row].indices.contains(result.col) {
                        updatedMilestones[result.row][result.col].image = result.image
                    }
                }
            }
            
            // 4. 새로 가져오고 처리된 데이터를 캐시합니다.
            self.allMilestones = updatedMilestones
            self.cachedBabyId = babyId
            
            return updatedMilestones
            
        case .failure(let error):
            print("🔴 [Repository] Failed to fetch milestones: \(error)")
            // 실패 시, 오래된 데이터를 보여주지 않기 위해 캐시를 비우고 기본 데이터를 반환합니다.
            clearCache()
            return GrowthMilestone.mockData
        }
    }
    
    /// 메모리 캐시를 무효화합니다.
    /// 데이터가 변경되거나(예: 마일스톤 업데이트), 사용자 컨텍스트가 변경될 때(예: 아기 변경, 로그아웃) 호출해야 합니다.
    func clearCache() {
        print("ℹ️ [Repository] Clearing milestone cache.")
        cachedBabyId = nil
        allMilestones = []
    }
}
