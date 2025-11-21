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
        let fetchedMilestones = await MilestoneRepository.shared.fetchAllMilestones(babyId: babyId)
        await MainActor.run {
            self.allMilestones = fetchedMilestones
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
            MilestoneRepository.shared.clearCache() // Clear repository cache on successful update
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
            MilestoneRepository.shared.clearCache() // Clear repository cache on successful delete
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
