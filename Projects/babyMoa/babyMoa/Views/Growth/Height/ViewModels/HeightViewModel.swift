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
    var babyId: Int
    
    init(babyId: Int) {
        self.babyId = babyId
    }
    
    @MainActor
    func fetchHeights() async {
        print("HeightViewModel: fetchHeights() - 아기 ID \(babyId)에 대한 키 기록을 가져올 예정입니다.")
        // TODO: 나중에는 babyId를 받아서 API 통신을 통해 데이터를 가져와야 합니다.
        self.records = HeightRecordModel.mockData
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
