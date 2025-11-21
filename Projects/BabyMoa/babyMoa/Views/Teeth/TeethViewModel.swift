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
        refreshEruptedTeethList()
    }
    
    func setTeethStatus(teethId: Int, deletion: Bool, eruptedDate: String?) async {
        guard let selectedBabyId = SelectedBabyState.shared.baby?.babyId else { return }
        
        let dateToUse = eruptedDate ?? DateFormatter.yyyyDashMMDashdd.string(from: .now)
        
        let result = await BabyMoaService.shared.postSetTeethStatus(babyId: selectedBabyId, teethId: teethId, date: dateToUse, deletion: deletion)
        
        switch result {
        case .success:
            if teethList.indices.contains(teethId) {
                teethList[teethId].erupted = !deletion
                teethList[teethId].eruptedDate = dateToUse
                refreshEruptedTeethList()
            }
        case .failure(let error):
            print("Error setting teeth status: \(error)")
        }
    }
    
    func refreshEruptedTeethList() {
        self.sortedEruptedTeethList = teethList.filter { $0.erupted && $0.eruptedDate != nil }
        .sorted(by: {
            let firstDate = DateFormatter.yyyyDashMMDashdd.date(from: $0.eruptedDate!) ?? Date()
            let secondDate = DateFormatter.yyyyDashMMDashdd.date(from: $1.eruptedDate!) ?? Date()
            return firstDate > secondDate
        })
    }
}

struct TeethData: Decodable, Hashable {
    var teethId: Int
    var eruptedDate: String?
    var erupted: Bool
    
    static let mockData: [TeethData] = (0..<20).map {
        TeethData(teethId: $0, erupted: false)
    }
}

/// 모델 매핑의 기준점 (Source of Truth)
struct TeethInfo {
    
    /// [1] 치아 이름 데이터 (ID 0~19 순서)
    /// 화면 배치 기준: 상단 줄 왼쪽부터 0번 ~ 하단 줄 오른쪽 끝 19번
    static let teethName: [String] = [
        // --- [Group 1] 위쪽 줄 (ID: 0 ~ 9) ---
        // 화면상의 숫자: 10, 5, 7, 3, 2 | 2, 3, 7, 5, 10
        "위 좌측 두 번째 어금니",  // ID 0
        "위 좌측 첫 번째 어금니",  // ID 1
        "위 좌측 송곳니",        // ID 2
        "위 좌측 옆니",          // ID 3
        "위 좌측 앞니",          // ID 4
        
        "위 우측 앞니",          // ID 5
        "위 우측 옆니",          // ID 6
        "위 우측 송곳니",        // ID 7
        "위 우측 첫 번째 어금니",  // ID 8
        "위 우측 두 번째 어금니",  // ID 9
        
        // --- [Group 2] 아래쪽 줄 (ID: 10 ~ 19) ---
        // 화면상의 숫자: 9, 6, 8, 4, 1 | 1, 4, 8, 6, 9
        "아래 좌측 두 번째 어금니", // ID 10
        "아래 좌측 첫 번째 어금니", // ID 11
        "아래 좌측 송곳니",       // ID 12
        "아래 좌측 옆니",         // ID 13
        "아래 좌측 앞니",         // ID 14
        
        "아래 우측 앞니",         // ID 15
        "아래 우측 옆니",         // ID 16
        "아래 우측 송곳니",       // ID 17
        "아래 우측 첫 번째 어금니", // ID 18
        "아래 우측 두 번째 어금니"  // ID 19
    ]
    
    /// [2] 화면 표시용 숫자 데이터 (ID 0~19 순서)
    /// 뷰에서는 이 배열을 참조하여 버튼에 숫자를 그립니다.
    static let teethNumber: [Int] = [
        // 위쪽 줄 (ID 0~9)
        10, 5, 7, 3, 2, 2, 3, 7, 5, 10,
        
        // 아래쪽 줄 (ID 10~19)
        9, 6, 8, 4, 1, 1, 4, 8, 6, 9
    ]
}
