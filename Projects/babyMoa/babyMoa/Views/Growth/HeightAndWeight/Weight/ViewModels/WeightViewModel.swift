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

    @Published var records: [WeightRecordModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var babyBirthday: Date? {
        return DateFormatter.yyyyDashMMDashdd.date(from: "2024-01-01")
    }
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
    }
    
    @MainActor
    func fetchWeights() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            // TODO: 나중에는 babyId를 받아서 API 통신을 통해 데이터를 가져와야 합니다.
            print("Fetching weights (using mock data)")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            let rawRecords = WeightRecordModel.mockData
            
            // 범용 GrowthRecordProcessor를 사용하여 데이터 가공
            self.records = GrowthRecordProcessor.process(records: rawRecords, babyBirthday: self.babyBirthday)
            
        } catch {
            errorMessage = "Failed to fetch weights: \(error.localizedDescription)"
            print(errorMessage!)
        }
    }
}
