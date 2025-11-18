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
    @Published var weightText: String = "7.5" // UI 바인딩용
    @Published var memo: String = ""
    @Published var errorMessage: String?
    @Published var showDatePicker: Bool = false
    
    // 몸무게 범위 (예: 2kg ~ 20kg)
    let minWeight: Double = 2.0
    let maxWeight: Double = 20.0

    init(coordinator: BabyMoaCoordinator, babyId: Int) {
        self.coordinator = coordinator
        self.babyId = babyId
    }

    func saveWeight() async {
        // 입력된 몸무게 값을 Double로 변환
        guard let finalWeight = Double(weightText) else {
            self.errorMessage = "유효한 몸무게 값을 입력해주세요."
            return
        }
        
        // 몸무게 값 범위 유효성 검사
        guard finalWeight >= minWeight && finalWeight <= maxWeight else {
            self.errorMessage = "몸무게 값은 \(minWeight)kg에서 \(maxWeight)kg 사이여야 합니다."
            return
        }

        let dateString = DateFormatter.yyyyDashMMDashdd.string(from: measuredDate)
        
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
