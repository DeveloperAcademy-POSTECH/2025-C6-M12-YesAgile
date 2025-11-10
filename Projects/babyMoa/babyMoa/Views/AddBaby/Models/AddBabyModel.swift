//
//  AddBabyModel.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import Foundation

// AddBabyModel은 아기 추가 화면에서 수집되는 핵심 데이터를 나타냅니다.
// 이 모델은 UI 상태나 비즈니스 로직을 포함하지 않고 순수하게 데이터 구조만을 정의합니다.
struct AddBabyModel: Codable, Identifiable, Hashable {
    let id: Int // 고유 식별자
    let babyId: Int
    var name: String
    var nickname: String? // 태명은 선택 사항
    var gender: String // "male", "female", "none" 중 하나
    var birthDate: Date // 'isBorn'=true면 생일, false면 예정일
    var relationship: String // RelationshipType의 rawValue (예: "아빠", "엄마")
    var profileImage: String
    var isBorn: Bool

    // 초기화 메서드
    init(id: Int = 0, babyId: Int = 0, name: String, nickname: String? = nil, gender: String, birthDate: Date, relationship: String, profileImage: String, isBorn: Bool = true) {
        self.id = id
        self.babyId = babyId
        self.name = name
        self.nickname = nickname
        self.gender = gender
        self.birthDate = birthDate
        self.relationship = relationship
        self.profileImage = profileImage
        self.isBorn = isBorn
    }
}


extension AddBabyModel {
    
    static var mockAddBabyModel: [AddBabyModel] = [
        
        // 1. 태어난 아기 (모든 정보 포함)
        AddBabyModel(
            id: 1,
            babyId: 1,
            name: "정우성",
            nickname: "쑥쑥이", // 태명
            gender: "male",
            birthDate: Calendar.current.date(byAdding: .month, value: -6, to: Date())!, // 6개월 전
            relationship: "아빠",
            profileImage: "baby_milestone_illustration", // 예시 이미지
            isBorn: true
        ),
        
        // 2. 태어나지 않은 아기 (예정일, 태명만 있음)
        AddBabyModel(
            id: 2,
            babyId: 2,
            name: "튼튼이", // (태어나기 전이라 태명을 이름으로 사용)
            nickname: "튼튼이",
            gender: "none", // (성별 아직 모름)
            birthDate: Calendar.current.date(byAdding: .month, value: 3, to: Date())!, // 3개월 후 예정일
            relationship: "엄마",
            profileImage: "baby_milestone_illustration",
            isBorn: false //  태어나지 않음
        ),
        
        // 3. 태어난 아기 (태명 없음)
        AddBabyModel(
            id: 3,
            babyId: 3,
            name: "정서아",
            nickname: nil, // 태명 없음
            gender: "female",
            birthDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!, // 1년 전
            relationship: "엄마",
            profileImage: "baby_milestone_illustration",
            isBorn: true
        )
    ]
}
