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
    let babyId: Int // babyId를 프로퍼티로 추가
    
    @Published var records: [HeightRecordModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var babyBirthday: Date? {
        // SelectedBabyState에서 아기의 실제 생년월일을 가져옵니다.
        return SelectedBabyState.shared.baby?.birthDate
    }
    
    init(coordinator: BabyMoaCoordinator, babyId: Int) { // init에서 babyId를 받도록 수정
        self.coordinator = coordinator
        self.babyId = babyId // 전달받은 babyId 할당
    }
    
    @MainActor
    func fetchHeights() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        // 실제 API 통신을 통해 데이터를 가져옵니다.
        let result = await BabyMoaService.shared.getGetHeights(babyId: self.babyId)
        
        switch result {
        case .success(let response):
            guard let apiRecords = response.data else {
                self.records = []
                return
            }
            
            // API 응답 (GetHeightsResModel)을 HeightRecordModel로 매핑
            let mappedRecords: [HeightRecordModel] = apiRecords.compactMap { apiRecord in
                guard let date = DateFormatter.yyyyDashMMDashdd.date(from: apiRecord.date) else {
                    print("Error: Could not parse date string \(apiRecord.date)")
                    return nil
                }
                return HeightRecordModel(
                    id: UUID(), // 각 기록에 고유한 ID 부여
                    date: date,
                    height: apiRecord.height,
                    memo: apiRecord.memo // memo 필드 포함
                )
            }
            
            // 범용 GrowthRecordProcessor를 사용하여 데이터 가공
            self.records = GrowthRecordProcessor.process(records: mappedRecords, babyBirthday: self.babyBirthday)
            
        case .failure(let error):
            errorMessage = "키 기록을 불러오는데 실패했습니다: \(error.localizedDescription)"
            print(errorMessage!)
        }
    }
}
