//
//  WeightViewModel.swift
//  BabyMoa
//
//  Created by Baba on 11/13/25.
//

import Foundation
import Combine

enum WeightTab: String, CaseIterable {
    case record = "기록"
    case chart = "차트"
}

final class WeightViewModel: ObservableObject {
    
    var coordinator: BabyMoaCoordinator
    let babyId: Int
    
    @Published var records: [WeightRecordModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>() // Combine 구독을 위한 cancellables 추가
    
    private var babyBirthday: Date? {
        if let baby = SelectedBabyState.shared.baby, let date = DateFormatter.yyyyDashMMDashdd.date(from: baby.birthDate) {
            return date
        }
        return nil
    }
    
    init(coordinator: BabyMoaCoordinator, babyId: Int) {
        self.coordinator = coordinator
        self.babyId = babyId
        
        // GrowthDataNotifier의 weightDidUpdate 알림을 구독합니다.
        GrowthDataNotifier.shared.weightDidUpdate
            .sink { [weak self] in
                print("WeightViewModel: Weight data updated notification received. Refreshing data.")
                Task {
                    await self?.fetchWeights()
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func navigateToWeightAdd() {
        coordinator.push(path: .newWeightAdd(babyId: self.babyId))
    }
    
    @MainActor
    func fetchWeights() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        let result = await BabyMoaService.shared.getGetWeights(babyId: self.babyId)
        
        switch result {
        case .success(let response):
            guard let apiRecords = response.data else {
                self.records = []
                return
            }
            
            let mappedRecords: [WeightRecordModel] = apiRecords.map { apiRecord in
                return WeightRecordModel(
                    weight: apiRecord.weight, // 순서 변경
                    date: apiRecord.date,
                    memo: apiRecord.memo
                )
            }
            
            self.records = GrowthRecordProcessor.process(records: mappedRecords, babyBirthday: self.babyBirthday)
            
        case .failure(let error):
            errorMessage = "몸무게 기록을 불러오는데 실패했습니다: \(error.localizedDescription)"
            print(errorMessage!)
        }
    }
    
    @MainActor
    func deleteWeightRecord(at offsets: IndexSet) {
        let recordsToDelete = offsets.map { self.records[$0] }
        
        Task {
            for record in recordsToDelete {
                let result = await BabyMoaService.shared.deleteWeight(babyId: self.babyId, date: record.date)
                
                switch result {
                case .success:
                    print("Successfully deleted weight record for date: \(record.date)")
                    DispatchQueue.main.async {
                        self.records.removeAll { $0.id == record.id }
                    }
                    
                case .failure(let error):
                    self.errorMessage = "몸무게 기록 삭제에 실패했습니다: \(error.localizedDescription)"
                    print(self.errorMessage!)
                }
            }
        }
    }
}
