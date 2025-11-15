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
            
            // 원본 데이터를 가공하여 View에 표시할 최종 records 생성
            self.records = process(rawRecords: rawRecords)
            
        } catch {
            errorMessage = "Failed to fetch heights: \(error.localizedDescription)"
            print(errorMessage!)
        }
    }
    
    // HeightRecordModel 배열을 받아 monthLabel과 diffText를 계산하여 반환하는 함수
    private func process(rawRecords: [HeightRecordModel]) -> [HeightRecordModel] {
        // 1. dateValue 계산 프로퍼티를 사용하여 측정 날짜 기준으로 오름차순 정렬
        var sortedRecords = rawRecords.sorted { $0.dateValue < $1.dateValue }
        
        // 2. 각 기록에 대해 monthLabel과 diffText 계산
        for i in 0..<sortedRecords.count {
            var currentRecord = sortedRecords[i]
            
            // monthLabel 계산
            currentRecord.monthLabel = calculateMonthLabel(from: currentRecord.dateValue)
            
            // diffText 계산
            if i > 0 { // 첫 번째 기록이 아닐 경우에만 계산
                let previousRecord = sortedRecords[i - 1]
                let difference = currentRecord.height - previousRecord.height
                currentRecord.diffText = String(format: "%+.1fcm", difference)
            } else {
                currentRecord.diffText = nil // 첫 번째 기록은 차이값이 없음
            }
            
            sortedRecords[i] = currentRecord // 수정된 레코드를 다시 배열에 할당
        }
        
        // 최신순으로 보여주기 위해 배열을 뒤집어서 반환
        return sortedRecords.reversed()
    }
    
    // 생후 몇 개월인지 계산하는 함수
    private func calculateMonthLabel(from measuredDate: Date) -> String? {
        guard let birthday = self.babyBirthday else { return nil }
        
        let components = Calendar.current.dateComponents([.month, .day], from: birthday, to: measuredDate)
        if let month = components.month, let day = components.day {
            return "생후 \(month)개월 \(day)일"
        }
        return nil
    }
}
