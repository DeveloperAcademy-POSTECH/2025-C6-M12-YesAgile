//
//  GrowthViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI
import Combine

@Observable
final class GrowthViewModel {
    var coordinator: BabyMoaCoordinator
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    // 좌측 상단 아기 정보 보여주기 위함
    var selectedBaby: BabySummary?
    
    var latestHeight: Double?
    var latestWeight: Double?
    
    var selectedMonthIdx: Int = 0
    
    var selectedMilestoneAgeRangeIdx: Int = 0
    var selectedMilestoneIdxInAgeRange: Int = 0
    
    var isMilestoneEditingViewPresented: Bool = false
    
    // 마일스톤 데이터 더 추가 예정
    var allMilestones: [[GrowthMilestone]] = GrowthMilestone.mockData
    
    
    // 서버에서 불러온 이빨 정보
    var teethList: [TeethData] = TeethData.mockData
    
    // MARK: - Stored Properties
    var selectedMilestone: GrowthMilestone {
        allMilestones[selectedMilestoneAgeRangeIdx][selectedMilestoneIdxInAgeRange]
    }
    
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        
        SelectedBabyState.shared.$baby
            .sink { [weak self] baby in
                guard let self = self, let baby = baby else { return }
                print("Selected baby changed to: \(baby.name) (ID: \(baby.babyId)). Fetching new growth data...")
                Task {
                    await self.fetchAllGrowthData(babyId: baby.babyId)
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchAllGrowthData(babyId: Int) async {
        await fetchSelectedBabySummary(babyId: babyId)
        await fetchAllMilestones(babyId: babyId)
        await fetchGrowthData(babyId: babyId)
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
    
    func setMilestone(milestone: GrowthMilestone) async -> Bool {
        guard let babyId = SelectedBabyState.shared.baby?.babyId else {
            print("Error: No baby selected for setting milestone.")
            return false
        }
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
    
    func fetchGrowthData(babyId: Int) async {
        let result = await BabyMoaService.shared.getGetGrowthData(babyId: babyId)
        
        print("----------- Growth Data API Response -----------")
        print("Fetching for babyId: \(babyId)")
        print(result)
        print("---------------------------------------------")
        
        switch result {
        case .success(let success):
            guard let data = success.data else {
                print("Growth data is nil.")
                return
            }
            await MainActor.run {
                print("Updating UI with latestHeight: \(data.latestHeight ?? -1), latestWeight: \(data.latestWeight ?? -1)")
                latestHeight = data.latestHeight
                latestWeight = data.latestWeight
                teethList = data.toothStatus
            }
        case .failure(let failure):
            print("Failed to fetch growth data: \(failure)")
        }
    }
    
    func fetchSelectedBabySummary(babyId: Int) async {
        let result = await BabyMoaService.shared.getBaby(babyId: babyId)
        switch result {
        case .success(let success):
            guard let babySummary = success.data else { return }
            let profileImage = await ImageManager.shared.downloadImage(from: babySummary.avatarImageName)
            self.selectedBaby = BabySummary(babyId: babyId, babyName: babySummary.name, babyProfileImage: profileImage)
            
        case .failure(let failure):
            print(failure)
        }
    }
    
    func deleteBabyMilestone() async {
        guard let babyId = SelectedBabyState.shared.baby?.babyId else {
            print("Error: No baby selected for deleting milestone.")
            return
        }
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
        allMilestones[selectedMilestoneAgeRangeIdx][selectedMilestoneIdxInAgeRange].image = nil
        allMilestones[selectedMilestoneAgeRangeIdx][selectedMilestoneIdxInAgeRange].completedDate = nil
        allMilestones[selectedMilestoneAgeRangeIdx][selectedMilestoneIdxInAgeRange].description = nil
        allMilestones[selectedMilestoneAgeRangeIdx][selectedMilestoneIdxInAgeRange].isCompleted = false
    }
    
    func beforeMilestoneButtonTapped() {
        if selectedMonthIdx <= 0 {
            return
        }
        selectedMonthIdx -= 1
    }
    
    func afterMilestoneButtonTapped() {
        if selectedMonthIdx >= allMilestones.count - 1 {
            return
        }
        selectedMonthIdx += 1
    }
    
    @MainActor
    func checkAllMilestonesButtonTapped() {
        coordinator.push(path: .allMilestones)
    }
    
    @MainActor
    func navigateToHeightDetail() {
        guard let babyId = SelectedBabyState.shared.baby?.babyId else {
            print("Error: No baby selected.")
            return
        }
        coordinator.push(path: .newHeight(babyId: babyId))
    }
    
    @MainActor
    func navigateToWeightDetail() {
        guard let babyId = SelectedBabyState.shared.baby?.babyId else {
            print("Error: No baby selected.")
            return
        }
        coordinator.push(path: .newWeight(babyId: babyId))
    }
    
    @MainActor
    func toothButtonTapped() {
        coordinator.push(path: .teeth(teethList: teethList))
    }
}
