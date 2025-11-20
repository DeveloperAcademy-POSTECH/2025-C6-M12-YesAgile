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
    let babyId: Int
    
    @Published var records: [HeightRecordModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>() // Combine 구독을 위한 cancellables 추가
    
    private var babyBirthday: Date? {
        // 1. birthDate가 String이므로 Date로 변환하여 반환합니다.
        if let baby = SelectedBabyState.shared.baby, let date = DateFormatter.yyyyDashMMDashdd.date(from: baby.birthDate) {
            return date
        }
        return nil
    }
    
    init(coordinator: BabyMoaCoordinator, babyId: Int) {
        self.coordinator = coordinator
        self.babyId = babyId
        
        // GrowthDataNotifier의 heightDidUpdate 알림을 구독합니다.
        GrowthDataNotifier.shared.heightDidUpdate
            .sink { [weak self] in
                print("HeightViewModel: Height data updated notification received. Refreshing data.")
                Task {
                    await self?.fetchHeights()
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func navigateToHeightAdd() {
        coordinator.push(path: .newHeightAdd(babyId: self.babyId))
    }
    
    @MainActor
    func fetchHeights() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        let result = await BabyMoaService.shared.getGetHeights(babyId: self.babyId)
        
        switch result {
        case .success(let response):
            guard let apiRecords = response.data else {
                self.records = []
                return
            }
            
            // 2. HeightRecordModel 생성자 오류 수정
            let mappedRecords: [HeightRecordModel] = apiRecords.map { apiRecord in
                return HeightRecordModel(
                    height: apiRecord.height, // 순서 변경
                    date: apiRecord.date,
                    memo: apiRecord.memo
                )
            }
            
            self.records = GrowthRecordProcessor.process(records: mappedRecords, babyBirthday: self.babyBirthday)
            
        case .failure(let error):
            errorMessage = "키 기록을 불러오는데 실패했습니다: \(error.localizedDescription)"
            print(errorMessage!)
        }
    }
    
    @MainActor
    func deleteHeightRecord(at offsets: IndexSet) {
        // 1. 삭제할 레코드 식별
        let recordsToDelete = offsets.map { self.records[$0] }
        
        Task {
            for record in recordsToDelete {
                // 2. API를 통해 서버에서 레코드 삭제
                let result = await BabyMoaService.shared.deleteHeight(babyId: self.babyId, date: record.date)
                
                switch result {
                case .success:
                    // 3. 성공 시 로컬 배열에서도 삭제
                    print("Successfully deleted height record for date: \(record.date)")
                    // UI 업데이트를 위해 메인 스레드에서 실행
                    DispatchQueue.main.async {
                        self.records.removeAll { $0.id == record.id }
                    }
                    
                case .failure(let error):
                    // 4. 실패 시 에러 메시지 표시
                    self.errorMessage = "키 기록 삭제에 실패했습니다: \(error.localizedDescription)"
                    print(self.errorMessage!)
                }
            }
        }
    }
}
