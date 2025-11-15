//
//  HeightViewModel.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
// 

import Foundation
import Combine

enum HeightTab: String, CaseIterable {
    case record = "기록"
    case chart = "차트"
}

final class HeightViewModel: ObservableObject {
    
    var coordinator: BabyMoaCoordinator

    @Published var records: [HeightRecordModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // 아기의 생년월일 정보 (SelectedBabyState에서 가져온다고 가정)
    private var babyBirthday: Date? {
        // 실제로는 SelectedBabyState.shared.baby?.birthday 등으로 가져와야 합니다.
        // 현재는 목업 데이터를 위해 임시로 설정합니다.
        return DateFormatter.yyyyDashMMDashdd.date(from: "2024-01-01")
    }
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
    }
    
    @MainActor
    func fetchHeights() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false } // Ensure isLoading is set to false when the function exits
        
        // let babyId = SelectedBabyState.shared.baby?.babyId // babyId는 API 통신 시에만 필요 추후에 guard로 해서 수정해야 한다
        
        do {
            // TODO: 나중에는 babyId를 받아서 API 통신을 통해 데이터를 가져와야 합니다.
            // 현재는 목업 데이터를 사용합니다.
            print("Fetching heights (using mock data)")
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
            
            // HeightRecordModel.mockData를 원본 데이터로 사용
            let rawRecords = HeightRecordModel.mockData
            
            // 범용 GrowthRecordProcessor를 사용하여 데이터 가공
            self.records = GrowthRecordProcessor.process(records: rawRecords, babyBirthday: self.babyBirthday)
            
        } catch {
            errorMessage = "Failed to fetch heights: \(error.localizedDescription)"
            print(errorMessage!)
        }
    }
}
