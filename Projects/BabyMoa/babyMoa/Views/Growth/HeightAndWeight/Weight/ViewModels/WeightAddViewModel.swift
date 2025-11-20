//
//  WeightAddViewModel.swift
//  BabyMoa
//
//  Created by Baba on 11/18/25.
//

import Foundation
import SwiftUI // For @MainActor
import Combine // For ObservableObject

@MainActor
final class WeightAddViewModel: ObservableObject {
    var coordinator: BabyMoaCoordinator
    let babyId: Int

    @Published var measuredDate: Date = Date()
    @Published var weightValue: Double = 7.5 // 초기값 설정
    @Published var memo: String = ""
    @Published var errorMessage: String?
    @Published var showDatePicker: Bool = false
    
    @Published var existingWeights: [GetWeightsResModel] = []
    
    // 몸무게 범위 (예: 2kg ~ 20kg)
    let minWeight: Double = 2.0
    let maxWeight: Double = 20.0

    init(coordinator: BabyMoaCoordinator, babyId: Int) {
        self.coordinator = coordinator
        self.babyId = babyId
        fetchExistingWeights()
    }
    
    private func fetchExistingWeights() {
        Task {
            let result = await BabyMoaService.shared.getGetWeights(babyId: self.babyId)
            switch result {
            case .success(let response):
                self.existingWeights = response.data ?? []
            case .failure(let error):
                self.errorMessage = "기존 몸무게 기록을 불러오는 데 실패했습니다: \(error.localizedDescription)"
            }
        }
    }

    func saveWeight() async {
        let finalWeight = self.weightValue
        
        // 몸무게 값 범위 유효성 검사
        guard finalWeight >= minWeight && finalWeight <= maxWeight else {
            self.errorMessage = "몸무게 값은 \(minWeight)kg에서 \(maxWeight)kg 사이여야 합니다."
            return
        }

        let dateString = DateFormatter.yyyyDashMMDashdd.string(from: measuredDate)
        
        let isDuplicate = existingWeights.contains { $0.date == dateString }
        
        if isDuplicate {
            self.errorMessage = "이미 해당 날짜에 기록이 존재합니다."
            return
        }
        
        let result = await BabyMoaService.shared.postSetWeight(
            babyId: self.babyId,
            weight: finalWeight,
            date: dateString,
            memo: self.memo.isEmpty ? nil : self.memo
        )

        switch result {
        case .success:
            // 저장이 성공하면 GrowthDataNotifier를 통해 알림을 보냅니다.
            GrowthDataNotifier.shared.weightDidUpdate.send()
            coordinator.pop()
        case .failure(let error):
            self.errorMessage = "몸무게 기록 저장에 실패했습니다: \(error.localizedDescription)"
        }
    }
}
