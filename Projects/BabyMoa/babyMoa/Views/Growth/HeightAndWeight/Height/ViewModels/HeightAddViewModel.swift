//
//  HeightAddViewModel.swift
//  BabyMoa
//
//  Created by Baba on 11/18/25.
//

import Foundation
import SwiftUI // For @MainActor
import Combine // For ObservableObject

@MainActor
final class HeightAddViewModel: ObservableObject {
    var coordinator: BabyMoaCoordinator
    let babyId: Int

    @Published var measuredDate: Date = Date()
    @Published var heightValue: Double = 73.1 // 초기값 설정
    @Published var heightText: String = "73.1" // UI 바인딩용
    @Published var memo: String = ""
    @Published var errorMessage: String?
    @Published var showDatePicker: Bool = false
    
    @Published var existingHeights: [GetHeightsResModel] = []
    
    // 키 범위 (예: 40cm ~ 120cm)
    let minHeight: Double = 40.0
    let maxHeight: Double = 120.0

    init(coordinator: BabyMoaCoordinator, babyId: Int) {
        self.coordinator = coordinator
        self.babyId = babyId
        fetchExistingHeights()
    }
    
    private func fetchExistingHeights() {
        Task {
            let result = await BabyMoaService.shared.getGetHeights(babyId: self.babyId)
            switch result {
            case .success(let response):
                self.existingHeights = response.data ?? []
            case .failure(let error):
                print("기존 키 기록을 가져오는 데 실패했습니다: \(error.localizedDescription)")
                self.errorMessage = "기존 기록을 불러오는 데 실패했습니다."
            }
        }
    }

    func saveHeight() async {
        print("saveHeight() 함수가 호출되었습니다.")

        let finalHeight = self.heightValue
        
        // 키 값 범위 유효성 검사
        guard finalHeight >= minHeight && finalHeight <= maxHeight else {
            self.errorMessage = "키 값은 \(minHeight)cm에서 \(maxHeight)cm 사이여야 합니다."
            return
        }

        let dateString = DateFormatter.yyyyDashMMDashdd.string(from: measuredDate)
        
        // 중복 날짜 확인
        let isDuplicate = existingHeights.contains { $0.date == dateString }
        
        if isDuplicate {
            self.errorMessage = "이미 해당 날짜에 기록이 존재합니다."
            return
        }
        
        let result = await BabyMoaService.shared.postSetHeight(
            babyId: self.babyId,
            height: finalHeight,
            date: dateString,
            memo: self.memo.isEmpty ? nil : self.memo
        )
        
        print("-----------API Response-----------")
        print(result)
        print("------------------------------------")

        switch result {
        case .success:
            // 저장이 성공하면 GrowthDataNotifier를 통해 알림을 보냅니다.
            GrowthDataNotifier.shared.heightDidUpdate.send()
            coordinator.pop()
        case .failure(let error):
            self.errorMessage = "키 기록 저장에 실패했습니다: \(error.localizedDescription)"
        }
    }
}
