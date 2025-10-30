//
//  GrowthDTO.swift
//  babyMoa
//
//  Created by Baba on 10/30/25.
//

import Foundation

// MARK: - API 응답 모델
/// 이미지 업로드 응답
struct ImageUploadResponse: Codable {
    let imageURL: String
}

/// 치아 기록 DTO (서버 데이터 형식)
struct TeethRecordDTO: Codable {
    let teethId: String
    let babyId: String
    let toothStatus: ToothPosition
    let hasErupted: Bool
    let date: String? // 서버에서는 날짜를 String으로 받음
    let memo: String?
}

// MARK: - API 요청 모델

/// 마일스톤 추가 요청
struct CreateMilestoneRequest: Codable {
    let babyId: String
    let title: String
    let ageRange: String
    let imageURL: String?
    let completedDate: String      // "yyyy.MM.dd.HH.mm.ss"
}

/// 키 추가 요청
struct CreateHeightRequest: Codable {
    let babyId: String
    let height: Double
    let date: String               // "yyyy.MM.dd.HH.mm.ss"
    let memo: String?
}

/// 몸무게 추가 요청
struct CreateWeightRequest: Codable {
    let babyId: String
    let weight: Double
    let date: String               // "yyyy.MM.dd.HH.mm.ss"
    let memo: String?
}

/// 치아 추가 요청
struct CreateTeethRequest: Codable {
    let babyId: String
    let position: String           // ToothPosition.rawValue
    let date: String               // "yyyy.MM.dd.HH.mm.ss"
    let memo: String?
}
