//
//  AllMilestoneViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/5/25.
//

import SwiftUI
import Foundation

@Observable
final class AllMilestoneViewModel {
    var coordinator: BabyMoaCoordinator
    var allMilestones: [[GrowthMilestone]]
    var isMilestoneEditingViewPresented: Bool = false
    var selectedCardRowIdx: Int = 0
    var selectedCardColIdx: Int = 0
    
    // MARK: Computed Properties
    var selectedMilestone: GrowthMilestone {
        allMilestones[selectedCardRowIdx][selectedCardColIdx]
    }
    
    init(coordinator: BabyMoaCoordinator, allMilestones: [[GrowthMilestone]]) {
        self.coordinator = coordinator
        self.allMilestones = allMilestones
    }
    
    func milestoneCardTapped(selectedCardRowIdx: Int, selectedCardColIdx: Int) {
        self.selectedCardRowIdx = selectedCardRowIdx
        self.selectedCardColIdx = selectedCardColIdx
        isMilestoneEditingViewPresented = true
    }
    
    func setMilestone(milestone: GrowthMilestone) async -> Bool {
        let result = await BabyMoaService.shared.postSetBabyMilestone(babyId: SelectedBaby.babyId!, milestoneName: milestone.id, milestoneImage: milestone.imageURL ?? "", date: DateFormatter.yyyyDashMMDashdd.string(from: milestone.completedDate ?? Date()), memo: milestone.description)
        switch result {
        case .success:
            return true
        case .failure(let error):
            print(error)
            return false
        }
    }
    
    func deleteBabyMilestone() async {
        let result = await BabyMoaService.shared.deleteBabyMilestone(babyId: SelectedBaby.babyId!, milestoneName: selectedMilestone.id)
        switch result {
        case .success:
            isMilestoneEditingViewPresented = false
            initiateSelectedMilestone()
        case .failure(let error):
            print(error)
        }
    }
    
    func initiateSelectedMilestone() {
        allMilestones[selectedCardRowIdx][selectedCardColIdx].imageURL = nil
        allMilestones[selectedCardRowIdx][selectedCardColIdx].completedDate = nil
        allMilestones[selectedCardRowIdx][selectedCardColIdx].description = nil
        allMilestones[selectedCardRowIdx][selectedCardColIdx].isCompleted = false
    }
}
