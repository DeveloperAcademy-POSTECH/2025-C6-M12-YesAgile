//
//  MilestoneRepository.swift
//  babyMoa
//
//  Created by Baba on 11/20/25.
//
//  This repository acts as a Single Source of Truth for milestone data.
//  It fetches data from the network and caches it in memory to prevent
//  redundant fetch operations across different ViewModels.
//

import SwiftUI

final class MilestoneRepository {
    static let shared = MilestoneRepository()
    
    private var cachedBabyId: Int?
    private var allMilestones: [[GrowthMilestone]] = []
    
    private init() {}
    
    /// Fetches all milestones for a given baby ID.
    /// It returns in-memory cached data if available for the same baby,
    /// otherwise, it fetches from the network.
    func fetchAllMilestones(babyId: Int) async -> [[GrowthMilestone]] {
        // 1. Return cached data if it's for the same baby and not empty.
        if let cachedBabyId = self.cachedBabyId, cachedBabyId == babyId, !allMilestones.isEmpty {
            print("✅ [Repository] Returning cached milestones for babyId: \(babyId)")
            return allMilestones
        }
        
        print("🟡 [Repository] No cached data. Fetching from server for babyId: \(babyId)")
        
        // 2. Fetch from the network.
        let result = await BabyMoaService.shared.getGetBabyMilestones(babyId: babyId)
        
        switch result {
        case .success(let success):
            guard let milestonesData = success.data else {
                // In case of success with no data, clear cache and return default.
                clearCache()
                return GrowthMilestone.mockData
            }
            
            var updatedMilestones = GrowthMilestone.mockData
            
            // 3. Process the data, including fetching images concurrently.
            // Using a TaskGroup is more performant for downloading multiple images.
            await withTaskGroup(of: (row: Int, col: Int, image: UIImage?).self) { group in
                for milestone in milestonesData {
                    let row = Int(milestone.milestoneName.split(separator: "_")[1])!
                    let col = Int(milestone.milestoneName.split(separator: "_")[2])!
                    
                    // Update non-image data immediately.
                    if updatedMilestones.indices.contains(row) && updatedMilestones[row].indices.contains(col) {
                        updatedMilestones[row][col].completedDate = DateFormatter.yyyyDashMMDashdd.date(from: milestone.date)
                        updatedMilestones[row][col].description = milestone.memo
                        updatedMilestones[row][col].isCompleted = true
                    }
                    
                    // Add a task to the group to download the image if a URL exists.
                    if let imageUrl = milestone.imageUrl, !imageUrl.isEmpty {
                        group.addTask {
                            // This now uses our image caching system automatically.
                            let image = await ImageManager.shared.downloadImage(from: imageUrl)
                            return (row, col, image)
                        }
                    }
                }
                
                // Collect the results of the image download tasks as they complete.
                for await result in group {
                    if updatedMilestones.indices.contains(result.row) && updatedMilestones[result.row].indices.contains(result.col) {
                        updatedMilestones[result.row][result.col].image = result.image
                    }
                }
            }
            
            // 4. Cache the newly fetched and processed data.
            self.allMilestones = updatedMilestones
            self.cachedBabyId = babyId
            
            return updatedMilestones
            
        case .failure(let error):
            print("🔴 [Repository] Failed to fetch milestones: \(error)")
            // On failure, clear cache and return default data to avoid showing stale data.
            clearCache()
            return GrowthMilestone.mockData
        }
    }
    
    /// Invalidates the in-memory cache.
    /// This should be called when data changes (e.g., a milestone is updated)
    /// or when the user context changes (e.g., switching babies, logging out).
    func clearCache() {
        print("ℹ️ [Repository] Clearing milestone cache.")
        cachedBabyId = nil
        allMilestones = []
    }
}
