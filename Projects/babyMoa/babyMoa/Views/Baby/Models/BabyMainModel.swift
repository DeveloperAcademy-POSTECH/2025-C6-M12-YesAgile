//
//  BabyModel.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import Foundation


struct Babies: Identifiable, Codable {
    
    let id: String
    let image: String
    let name: String
    let nickname: String
    let date: Date
    let gender : String
    let relationship: String
}


extension Babies {
    /// 아기 3명 목록 목업 데이터
    static var mockBabies: [Babies] = [
        Babies(
            id: UUID().uuidString,
            image: "baby_milestone_illustration", // UIKIT 임포트해서 서버스 URL - DTO로 마
            name: "정우성",
            nickname: "씩씩이",
            date: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
            gender: "남아",
            relationship: "아빠"
        ),
        Babies(
            id: UUID().uuidString,
            image: "baby_milestone_illustration",
            name: "정서아",
            nickname: "공주님",
            date: Calendar.current.date(byAdding: .month, value: -6, to: Date())!,
            gender: "여아",
            relationship: "엄마"
        ),
        Babies(
            id: UUID().uuidString,
            image: "baby_milestone_illustration",
            name: "정시우",
            nickname: "왕자님",
            date: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
            gender: "여아",
            relationship: "엄마"
        )
    ]
}