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
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
    }
    
    @MainActor
    func fetchHeights() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false } // Ensure isLoading is set to false when the function exits
        
        let babyId = SelectedBabyState.shared.baby?.babyId // babyId는 API 통신 시에만 필요 추후에 guard로 해서 수정해야 한다
        
        do {
            // TODO: 나중에는 babyId를 받아서 API 통신을 통해 데이터를 가져와야 합니다.
            // 현재는 목업 데이터를 사용합니다.
            print("Fetching heights (using mock data)")
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
//            self.records = HeightRecordModel.mockData
        } catch {
            errorMessage = "Failed to fetch heights: \(error.localizedDescription)"
            print(errorMessage!)
        }
    }
}
