//
//  HeightViewModel.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import Foundation

enum HeightTab: String, CaseIterable {
    case record = "기록"
    case chart = "차트"
}

@Observable
final class HeightViewModel {
    var records: [HeightRecordModel] = []
    var coordinator: BabyMoaCoordinator
    var babyId: Int
    
    // 아기 생년월일 (서버 API 문제로 인해 임시로 하드코딩)
    // 실제 API 연동 시에는 API를 통해 가져와야 합니다.
    let babyBirthDate: Date = DateFormatter.yyyyDashMMDashdd.date(from: "2024-09-01")! // 예시: 2024년 9월 1일
    
    init (babyId: Int, coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        self.babyId = 1
    }
    
    @MainActor
    func fetchHeights() async {
        print("HeightViewModel: fetchHeights() - 아기 ID \(babyId)에 대한 키 기록을 가져올 예정입니다.")
        print("Debug: babyBirthDate = \(babyBirthDate)") // Debug print
        
        // 1. 목업 데이터 사용 (API 문제 해결 시 BabyMoaService 호출로 대체)
        var fetchedRecords = HeightRecordModel.mockData // mutable copy
        
        // 2. 기록을 날짜 순으로 정렬 (diffText 계산을 위해 필요)
        fetchedRecords.sort { $0.date < $1.date } // 오름차순 정렬 (가장 오래된 날짜부터)
        
        // 3. monthLabel과 diffText 계산 및 HeightRecordModel 업데이트
        var previousValue: Double? = nil
        
        // fetchedRecords는 이제 monthLabel과 diffText를 포함하고 있으므로,
        // 이들을 덮어쓰는 방식으로 계산된 값을 할당합니다.
        for i in 0..<fetchedRecords.count {
            var record = fetchedRecords[i] // 배열에서 변경 가능한 복사본을 가져옴
            
            // Debug prints for monthLabel calculation
            print("Debug: record.date = \(record.date)")
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month, .day], from: babyBirthDate, to: record.date)
            print("Debug: components for \(record.date): months = \(components.month ?? -1), days = \(components.day ?? -1)")
            
            // monthLabel 계산
            record.monthLabel = GrowthDataCalculator.calculateMonthLabel(recordDate: record.date, birthDate: babyBirthDate)
            
            // diffText 계산
            record.diffText = GrowthDataCalculator.calculateDiffText(currentValue: record.value, previousValue: previousValue)
            
            fetchedRecords[i] = record // 수정된 복사본을 배열에 다시 할당
            
            previousValue = record.value // 다음 기록을 위해 현재 값 저장
        }
        
        // 4. 최종적으로 계산된 기록을 내림차순으로 정렬하여 ViewModel의 records 업데이트
        self.records = fetchedRecords.reversed() // 내림차순으로 변경
    }
    
    @MainActor
    func addHeight(height: Double, date: Date, memo: String?) async {
        print("HeightViewModel: addHeight() - 아기 ID \(babyId)에 새로운 키 기록을 추가할 예정입니다. 키: \(height)cm, 날짜: \(date), 메모: \(memo ?? "없음")")
        // TODO: API를 통해 새로운 키 기록을 추가하는 로직 구현
    }
    
    @MainActor
    func updateHeight(id: UUID, height: Double, date: Date, memo: String?) async {
        print("HeightViewModel: updateHeight() - 아기 ID \(babyId)의 키 기록 \(id)를 업데이트할 예정입니다. 키: \(height)cm, 날짜: \(date), 메모: \(memo ?? "없음")")
        // TODO: API를 통해 기존 키 기록을 업데이트하는 로직 구현
    }
    
    @MainActor
    func deleteHeight(id: UUID) async {
        print("HeightViewModel: deleteHeight() - 아기 ID \(babyId)의 키 기록 \(id)를 삭제할 예정입니다.")
        // TODO: API를 통해 키 기록을 삭제하는 로직 구현
    }
}
