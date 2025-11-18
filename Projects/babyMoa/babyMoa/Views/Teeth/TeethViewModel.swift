//
//  TeethViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/3/25.
//

import SwiftUI

@Observable
final class TeethViewModel {
    var coordinator: BabyMoaCoordinator
    var teethList: [TeethData] = TeethData.mockData
    var sortedEruptedTeethList: [TeethData] = []
    
    init(coordinator: BabyMoaCoordinator, teethList: [TeethData]) {
        self.coordinator = coordinator
        self.teethList = teethList
        // 현재 난 치아 상태 초기화 (최신순 정렬하여 리스트로 보여주기 위해서)
        refreshEruptedTeethList()
    }
    
    func setTeethStatus(teethId: Int, deletion: Bool, eruptedDate: String?) async {
        guard let selectedBabyId = SelectedBabyState.shared.baby?.babyId else { return }
        if let date = eruptedDate {
            let result = await BabyMoaService.shared.postSetTeethStatus(babyId: selectedBabyId, teethId: teethId, date: date, deletion: deletion)
            switch result {
            case .success:
                // 로컬 치아 상태도 변경
                teethList[teethId].erupted = !deletion
                teethList[teethId].eruptedDate = date
                refreshEruptedTeethList()
            case .failure(let error):
                print(error)
            }
        }
        else {
            let nowString = DateFormatter.yyyyDashMMDashdd.string(from: .now)
            let result = await BabyMoaService.shared.postSetTeethStatus(babyId: selectedBabyId, teethId: teethId, date: nowString, deletion: deletion)
            switch result {
            case .success:
                // 로컬 치아 상태도 변경
                teethList[teethId].erupted = !deletion
                teethList[teethId].eruptedDate = nowString
                refreshEruptedTeethList()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshEruptedTeethList() {
        self.sortedEruptedTeethList = teethList.filter { $0.erupted && $0.eruptedDate != nil }
        .sorted(by: {
            let firstDate = DateFormatter.yyyyDashMMDashdd.date(from: $0.eruptedDate!)
            let secondDate = DateFormatter.yyyyDashMMDashdd.date(from: $1.eruptedDate!)
            return firstDate! > secondDate!
        })
    }
}

struct TeethData: Decodable, Hashable {
    var teethId: Int
    var eruptedDate: String?
    var erupted: Bool
    
    static let mockData: [TeethData] = [
        TeethData(teethId: 0, erupted: false),
        TeethData(teethId: 1, erupted: false),
        TeethData(teethId: 2, erupted: false),
        TeethData(teethId: 3, erupted: false),
        TeethData(teethId: 4, erupted: false),
        TeethData(teethId: 5, erupted: false),
        TeethData(teethId: 6, erupted: false),
        TeethData(teethId: 7, erupted: false),
        TeethData(teethId: 8, erupted: false),
        TeethData(teethId: 9, erupted: false),
        TeethData(teethId: 10, erupted: false),
        TeethData(teethId: 11, erupted: false),
        TeethData(teethId: 12, erupted: false),
        TeethData(teethId: 13, erupted: false),
        TeethData(teethId: 14, erupted: false),
        TeethData(teethId: 15, erupted: false),
        TeethData(teethId: 16, erupted: false),
        TeethData(teethId: 17, erupted: false),
        TeethData(teethId: 18, erupted: false),
        TeethData(teethId: 19, erupted: false),
    ]
}

struct TeethInfo {
    /// 각 이빨의 20개 인덱스 (위 좌측 -> 아래 우측 순) 에 해당하는 이빨 이름입니다.
    static let teethName: [String] = [
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니",
        "위 좌측 뒤어금니"
    ]
    
    /// 각 이빨의 20개 인덱스 (위 좌측 -> 아래 우측 순)에 해당하는 이빨이 나는 순서입니다.
    static let teethNumber: [Int] = [
        10, 5, 7, 3, 2, 2, 3, 7, 5, 10,
        9, 6, 8, 4, 1, 1, 4, 8, 6, 9
    ]
}
