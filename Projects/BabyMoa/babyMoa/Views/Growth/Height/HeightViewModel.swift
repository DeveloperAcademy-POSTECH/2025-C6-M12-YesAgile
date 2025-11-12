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
    
    init() {
        // TODO: 나중에는 babyId를 받아서 API 통신을 통해 데이터를 가져와야 합니다.
        self.records = HeightRecordModel.mockData
    }
}
