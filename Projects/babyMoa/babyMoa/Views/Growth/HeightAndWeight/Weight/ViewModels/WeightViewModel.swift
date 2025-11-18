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
    
    private var babyBirthday: Date? {
        return SelectedBabyState.shared.baby?.birthDate
    }
    
    init(coordinator: BabyMoaCoordinator, babyId: Int) {
        self.coordinator = coordinator
        self.babyId = babyId
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
            
            let mappedRecords: [WeightRecordModel] = apiRecords.compactMap { apiRecord in
                guard let date = DateFormatter.yyyyDashMMDashdd.date(from: apiRecord.date) else {
                    print("Error: Could not parse date string \(apiRecord.date)")
                    return nil
                }
                return WeightRecordModel(
                    id: UUID(),
                    date: date,
                    weight: apiRecord.weight,
                    memo: apiRecord.memo
                )
            }
            
            self.records = GrowthRecordProcessor.process(records: mappedRecords, babyBirthday: self.babyBirthday)
            
        case .failure(let error):
            errorMessage = "몸무게 기록을 불러오는데 실패했습니다: \(error.localizedDescription)"
            print(errorMessage!)
        }
    }
}
