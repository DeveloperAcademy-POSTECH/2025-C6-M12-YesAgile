//
//  BabyModel.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import Foundation


struct Babies: Identifiable, Codable {
    let babyId: Int
    let alias: String
    let name: String
    let birthDate: String
    let gender: String
    let avatarImageName: String

    // Identifiable 프로토콜 준수를 위해 id 프로퍼티 추가
    var id: Int { babyId }
}


extension Babies {
    /// 아기 3명 목록 목업 데이터
    static var mockBabies: [Babies] = [
        Babies(
            babyId: 1,
            alias: "씩씩이",
            name: "정우성",
            birthDate: "2025-10-10",
            gender: "M",
            avatarImageName: "baby_milestone_illustration"
        ),
        Babies(
            babyId: 2,
            alias: "공주님",
            name: "정서아",
            birthDate: "2025-05-10",
            gender: "F",
            avatarImageName: "baby_milestone_illustration"
        ),
        Babies(
            babyId: 3,
            alias: "왕자님",
            name: "정시우",
            birthDate: "2024-11-10",
            gender: "F",
            avatarImageName: "baby_milestone_illustration"
        )
    ]
}