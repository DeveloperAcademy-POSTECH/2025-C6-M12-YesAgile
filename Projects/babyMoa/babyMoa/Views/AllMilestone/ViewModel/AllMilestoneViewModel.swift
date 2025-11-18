//
//  AllMilestoneViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/5/25.
//

import SwiftUI
import Combine
import Foundation

@Observable
final class AllMilestoneViewModel {
    var coordinator: BabyMoaCoordinator
    var allMilestones: [[GrowthMilestone]] = GrowthMilestone.mockData
    var isMilestoneEditingViewPresented: Bool = false
    var selectedCardRowIdx: Int = 0
    var selectedCardColIdx: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Computed Properties
    var selectedMilestone: GrowthMilestone {
        allMilestones[selectedCardRowIdx][selectedCardColIdx]
    }
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        
        SelectedBabyState.shared.$baby
            .sink { [weak self] baby in
                guard let self = self, let baby = baby else { return }
                Task {
                    await self.fetchAllMilestones(babyId: baby.babyId)
                }
            }
            .store(in: &cancellables)
        
        // Fetch initial data if a baby is already selected
        if let baby = SelectedBabyState.shared.baby {
            Task {
                await fetchAllMilestones(babyId: baby.babyId)
            }
        }
    }
    
    func fetchAllMilestones(babyId: Int) async {
        let result = await BabyMoaService.shared.getGetBabyMilestones(babyId: babyId)
        switch result {
        case .success(let success):
            guard let milestonesData = success.data else { return }
            
            var updatedMilestones = GrowthMilestone.mockData
            
            for milestone in milestonesData {
                let row = Int(milestone.milestoneName.split(separator: "_")[1])!
                let col = Int(milestone.milestoneName.split(separator: "_")[2])!
                
                if updatedMilestones.indices.contains(row) && updatedMilestones[row].indices.contains(col) {
                    var decodedImage: UIImage?
                    if let imageUrl = milestone.imageUrl {
                        decodedImage = await ImageManager.shared.downloadImage(from: imageUrl)
                    }
                    
                    updatedMilestones[row][col].image = decodedImage
                    updatedMilestones[row][col].completedDate = DateFormatter.yyyyDashMMDashdd.date(from: milestone.date)
                    updatedMilestones[row][col].description = milestone.memo
                    updatedMilestones[row][col].isCompleted = true
                }
            }
            
            let finalMilestones = updatedMilestones
            await MainActor.run {
                self.allMilestones = finalMilestones
            }
            
        case .failure(let error):
            print(error)
        }
    }
    
    func milestoneCardTapped(selectedCardRowIdx: Int, selectedCardColIdx: Int) {
        self.selectedCardRowIdx = selectedCardRowIdx
        self.selectedCardColIdx = selectedCardColIdx
        isMilestoneEditingViewPresented = true
    }
    
    func setMilestone(milestone: GrowthMilestone) async -> Bool {
        guard let babyId = SelectedBabyState.shared.baby?.babyId else { return false }
        
        var base64EncodedImage: String?
        if let image = milestone.image {
            base64EncodedImage = ImageManager.shared.encodeToBase64(image)
        }
        
        let result = await BabyMoaService.shared.postSetBabyMilestone(babyId: babyId, milestoneName: milestone.id, milestoneImage: base64EncodedImage ?? "", date: DateFormatter.yyyyDashMMDashdd.string(from: milestone.completedDate ?? Date()), memo: milestone.description)
        
        switch result {
        case .success:
            return true
        case .failure(let error):
            print(error)
            return false
        }
    }
    
    func deleteBabyMilestone() async {
        guard let babyId = SelectedBabyState.shared.baby?.babyId else { return }
        let result = await BabyMoaService.shared.deleteBabyMilestone(babyId: babyId, milestoneName: selectedMilestone.id)
        switch result {
        case .success:
            isMilestoneEditingViewPresented = false
            initiateSelectedMilestone()
        case .failure(let error):
            print(error)
        }
    }
    
    func initiateSelectedMilestone() {
        allMilestones[selectedCardRowIdx][selectedCardColIdx].image = nil
        allMilestones[selectedCardRowIdx][selectedCardColIdx].completedDate = nil
        allMilestones[selectedCardRowIdx][selectedCardColIdx].description = nil
        allMilestones[selectedCardRowIdx][selectedCardColIdx].isCompleted = false
    }
}
