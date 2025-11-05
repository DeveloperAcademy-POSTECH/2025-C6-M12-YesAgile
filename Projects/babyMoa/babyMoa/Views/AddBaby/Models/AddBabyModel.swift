//
//  AddBabyModel.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import Foundation

// AddBabyModel은 아기 추가 화면에서 수집되는 핵심 데이터를 나타냅니다.
// 이 모델은 UI 상태나 비즈니스 로직을 포함하지 않고 순수하게 데이터 구조만을 정의합니다.
struct AddBabyModel: Codable, Identifiable {
    let id: UUID // 고유 식별자
    var name: String
    var nickname: String? // 태명은 선택 사항
    var gender: String // "male", "female", "none" 중 하나
    var birthDate: Date
    var relationship: String // RelationshipType의 rawValue (예: "아빠", "엄마")
    var profileImage: String

    // 초기화 메서드
    init(id: UUID = UUID(), name: String, nickname: String? = nil, gender: String, birthDate: Date, relationship: String, profileImage: String) {
        self.id = id
        self.name = name
        self.nickname = nickname
        self.gender = gender
        self.birthDate = birthDate
        self.relationship = relationship
        self.profileImage = profileImage
    }
}
