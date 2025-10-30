//
//  GrowthData.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  성장 기록 관련 데이터 모델
//

import Foundation
import SwiftUI

// MARK: - 성장 마일스톤

/// 성장 마일스톤 항목
struct GrowthMilestone: Identifiable, Codable {
    let id: String
    let title: String              // 마일스톤 제목 (예: "화내기", "기기")
    let ageRange: String           // 월령 범위 (예: "0~2개월") 2개월 단위, 3~4개월
    var imageURL: String?          // 등록된 이미지 URL
    var isCompleted: Bool          // 완료 여부
    var completedDate: Date?       // 완료 날짜
    let description: String?       // 설명 (선택)
    let illustrationName: String?  // 기본 일러스트 이름 (예: "Baby01")
    
    init(
        id: String = UUID().uuidString,
        title: String,
        ageRange: String,
        imageURL: String? = nil,
        isCompleted: Bool = false,
        completedDate: Date? = nil,
        description: String? = nil,
        illustrationName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.ageRange = ageRange
        self.imageURL = imageURL
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.description = description
        self.illustrationName = illustrationName
    }
}

// MARK: - 키/몸무게 기록

/// 키 기록
struct HeightRecord: Identifiable, Codable {
    let id: String
    let babyId: String             // 아기 ID
    let height: Double             // 키 (cm)
    let date: Date                 // 측정 날짜
    let memo: String?              // 메모 (선택)
    
    init(
        id: String = UUID().uuidString,
        babyId: String,
        height: Double,
        date: Date = Date(),
        memo: String? = nil
    ) {
        self.id = id
        self.babyId = babyId
        self.height = height
        self.date = date
        self.memo = memo
    }
    
    /// 날짜 포맷 (예: "2025.10.22")
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}

/// 몸무게 기록
struct WeightRecord: Identifiable, Codable {
    let id: String
    let babyId: String             // 아기 ID
    let weight: Double             // 몸무게 (kg)
    let date: Date                 // 측정 날짜
    let memo: String?              // 메모 (선택)
    
    init(
        id: String = UUID().uuidString,
        babyId: String,
        weight: Double,
        date: Date = Date(),
        memo: String? = nil
    ) {
        self.id = id
        self.babyId = babyId
        self.weight = weight
        self.date = date
        self.memo = memo
    }
    
    /// 날짜 포맷 (예: "2025.10.22")
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}

// MARK: - 치아 기록

/// 치아 위치 (영구치 번호 기준) -> 우리앱의 1~20 기준으로 맞춰야함
enum ToothPosition: String, Codable, CaseIterable {
    // 상악 (위)
    case upperRight8 = "상악_우측_8"
    case upperRight7 = "상악_우측_7"
    case upperRight6 = "상악_우측_6"
    case upperRight5 = "상악_우측_5"
    case upperRight4 = "상악_우측_4"
    case upperRight3 = "상악_우측_3"
    case upperRight2 = "상악_우측_2"
    case upperRight1 = "상악_우측_1"
    case upperLeft1 = "상악_좌측_1"
    case upperLeft2 = "상악_좌측_2"
    case upperLeft3 = "상악_좌측_3"
    case upperLeft4 = "상악_좌측_4"
    case upperLeft5 = "상악_좌측_5"
    case upperLeft6 = "상악_좌측_6"
    case upperLeft7 = "상악_좌측_7"
    case upperLeft8 = "상악_좌측_8"
    
    // 하악 (아래)
    case lowerRight8 = "하악_우측_8"
    case lowerRight7 = "하악_우측_7"
    case lowerRight6 = "하악_우측_6"
    case lowerRight5 = "하악_우측_5"
    case lowerRight4 = "하악_우측_4"
    case lowerRight3 = "하악_우측_3"
    case lowerRight2 = "하악_우측_2"
    case lowerRight1 = "하악_우측_1"
    case lowerLeft1 = "하악_좌측_1"
    case lowerLeft2 = "하악_좌측_2"
    case lowerLeft3 = "하악_좌측_3"
    case lowerLeft4 = "하악_좌측_4"
    case lowerLeft5 = "하악_좌측_5"
    case lowerLeft6 = "하악_좌측_6"
    case lowerLeft7 = "하악_좌측_7"
    case lowerLeft8 = "하악_좌측_8"
    
    /// 표시 이름
    var displayName: String {
        return self.rawValue
    }
}

// popover(item:) 사용을 위해 Identifiable 채택
extension ToothPosition: Identifiable {
    var id: String { rawValue }
}

/// 치아 기록
struct TeethRecord: Identifiable, Codable {
    let id: String
    let babyId: String             // 아기 ID
    let position: ToothPosition    // 치아 위치
    let hasErupted: Bool           // 이가 났는지 (true: 남, false: 안남)
    let date: Date?                // 나온 날짜 (Optional - 안 났으면 nil)
    let memo: String?              // 메모 (선택)
    
    // MARK: - Custom Codable (백엔드 형식 변환)
    
    enum CodingKeys: String, CodingKey {
        case id = "teethId"        // 백엔드: teethId
        case babyId
        case position = "toothStatus"  // 백엔드: toothStatus
        case hasErupted           // 백엔드: Boolean
        case date
        case memo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        babyId = try container.decode(String.self, forKey: .babyId)
        position = try container.decode(ToothPosition.self, forKey: .position)
        hasErupted = try container.decode(Bool.self, forKey: .hasErupted)
        memo = try container.decodeIfPresent(String.self, forKey: .memo)
        
        // ✅ 날짜 String → Date 변환 (Optional)
        if let dateString = try container.decodeIfPresent(String.self, forKey: .date) {
            date = TeethRecord.dateFromBackendString(dateString)
        } else {
            date = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(babyId, forKey: .babyId)
        try container.encode(position, forKey: .position)
        try container.encode(hasErupted, forKey: .hasErupted)
        try container.encodeIfPresent(memo, forKey: .memo)
        
        // ✅ Date → String 변환 (Optional)
        if let date = date {
            let dateString = TeethRecord.backendStringFromDate(date)
            try container.encode(dateString, forKey: .date)
        } else {
            try container.encodeNil(forKey: .date)
        }
    }
    
    // MARK: - 일반 Initializer (앱 내부에서 사용)
    
    init(
        id: String = UUID().uuidString,
        babyId: String,
        position: ToothPosition,
        hasErupted: Bool = true,
        date: Date? = Date(),
        memo: String? = nil
    ) {
        self.id = id
        self.babyId = babyId
        self.position = position
        self.hasErupted = hasErupted
        self.date = date
        self.memo = memo
    }
    
    // MARK: - Date Conversion Helpers
    
    /// 백엔드 형식 String → Date 변환
    /// - Parameter string: "2024.10.26.14.30.00"
    /// - Returns: Date?
    static func dateFromBackendString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd.HH.mm.ss"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: string)
    }
    
    /// Date → 백엔드 형식 String 변환
    /// - Parameter date: Date
    /// - Returns: "2024.10.26.14.30.00"
    static func backendStringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd.HH.mm.ss"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    // MARK: - Computed Properties
    
    /// 날짜 포맷 (예: "2024년 10월 26일")
    var formattedDate: String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    /// 날짜 표시용 (짧은 형식: "2024.10.26")
    var shortFormattedDate: String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}

// MARK: - 샘플 데이터

//extension GrowthMilestone {
//    /// 0~2개월 마일스톤 샘플
//    static let sampleAge0to2: [GrowthMilestone] = [
//        GrowthMilestone(title: "화내기", ageRange: "0~2개월", description: "나도 화낼 수 있어요!"),
//        GrowthMilestone(title: "기기", ageRange: "0~2개월", description: "첫 기어가기 도전"),
//    ]
//    
//    /// 전체 마일스톤 샘플
//    static let allSamples: [GrowthMilestone] = [
//        GrowthMilestone(title: "화내기", ageRange: "0~2개월"),
//        GrowthMilestone(title: "기기", ageRange: "0~2개월"),
//        GrowthMilestone(title: "키", ageRange: "3~5개월"),
//        GrowthMilestone(title: "몸무게", ageRange: "3~5개월"),
//    ]
//}


