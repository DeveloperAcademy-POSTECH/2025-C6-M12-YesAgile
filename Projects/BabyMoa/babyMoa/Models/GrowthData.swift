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
/// 사용자가 사진, 메모를 입력하고 저장하면 [imageURL, description, completedDate] 가 추가됨.
struct GrowthMilestone: Identifiable, Hashable {
    let id: String
    let title: String              // 마일스톤 제목 (예: "화내기", "기기")
    let ageRange: String           // 월령 범위 (예: "0~2개월") 2개월 단위, 3~4개월
    var image: UIImage?          // 등록된 이미지 URL
    var isCompleted: Bool          // 완료 여부
    var completedDate: Date?       // 완료 날짜
    var description: String?       // 설명 (선택)
    let illustrationName: String?  // 기본 일러스트 이름 (예: "Baby01")
    
    init(
        id: String = UUID().uuidString,
        title: String,
        ageRange: String,
        image: UIImage? = nil,
        isCompleted: Bool = false,
        completedDate: Date? = nil,
        description: String? = nil,
        illustrationName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.ageRange = ageRange
        self.image = image
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.description = description
        self.illustrationName = illustrationName
    }
    
    static let mockData: [[GrowthMilestone]] = [
        // 0~2개월
        [
            GrowthMilestone(id: "milestone_0_0", title: "누워있기", ageRange: "1단계", isCompleted: false, completedDate: nil, illustrationName: "Baby01"),
            GrowthMilestone(id: "milestone_0_1", title: "손발 움직이기", ageRange: "1단계", isCompleted: false, completedDate: nil, illustrationName: "Baby02"),
            GrowthMilestone(id: "milestone_0_2", title: "빛 반응하기", ageRange: "1단계", isCompleted: false, completedDate: nil, illustrationName: "Baby03"),
            GrowthMilestone(id: "milestone_0_3", title: "소리 반응하기", ageRange: "1단계", isCompleted: false, completedDate: nil, illustrationName: "Baby04"),
            GrowthMilestone(id: "milestone_0_4", title: "얼굴 인식하기", ageRange: "1단계", isCompleted: false, completedDate: nil, illustrationName: "Baby05"),
            GrowthMilestone(id: "milestone_0_5", title: "울기", ageRange: "1단계", isCompleted: false, completedDate: nil, illustrationName: "Baby06"),
        ],
        // 3~4개월
        [
            GrowthMilestone(id: "milestone_1_0", title: "목가누기", ageRange: "2단계", isCompleted: false, completedDate: nil, illustrationName: "Baby07"),
            GrowthMilestone(id: "milestone_1_1", title: "머리들기", ageRange: "2단계",isCompleted: false, completedDate: nil, illustrationName: "Baby08"),
            GrowthMilestone(id: "milestone_1_2", title: "물건 잡기", ageRange: "2단계", isCompleted: false, completedDate: nil, illustrationName: "Baby09"),
            GrowthMilestone(id: "milestone_1_3", title: "옹알이 시작하기", ageRange: "2단계",isCompleted: false, completedDate: nil, illustrationName: "Baby10"),
            GrowthMilestone(id: "milestone_1_4", title: "시선 이동하기", ageRange: "2단계",isCompleted: false, completedDate: nil, illustrationName: "Baby11"),
            GrowthMilestone(id: "milestone_1_5", title: "웃기", ageRange: "2단계",isCompleted: false, completedDate: nil, illustrationName: "Baby12"),
        ],
        // 5~6개월
        [
            GrowthMilestone(id: "milestone_2_0", title: "혼자 뒤집기", ageRange: "3단계", isCompleted: false, completedDate: nil, illustrationName: "Baby13"),
            GrowthMilestone(id: "milestone_2_1", title: "발차기", ageRange: "3단계", isCompleted: false, completedDate: nil, illustrationName: "Baby14"),
            GrowthMilestone(id: "milestone_2_2", title: "손 뻗기", ageRange: "3단계", isCompleted: false, completedDate: nil, illustrationName: "Baby15"),
            GrowthMilestone(id: "milestone_2_3", title: "물건 잡아 들기", ageRange: "3단계", isCompleted: false, completedDate: nil, illustrationName: "Baby16"),
            GrowthMilestone(id: "milestone_2_4", title: "이름 반응하기", ageRange: "3단계", isCompleted: false, completedDate: nil, illustrationName: "Baby17"),
            GrowthMilestone(id: "milestone_2_5", title: "낯가림하기", ageRange: "3단계", isCompleted: false, completedDate: nil, illustrationName: "Baby18"),
        ],
        // 7~8개월
        [
            GrowthMilestone(id: "milestone_3_0", title: "혼자 앉기", ageRange: "4단계", isCompleted: false, completedDate: nil, illustrationName: "Baby19"),
            GrowthMilestone(id: "milestone_3_1", title: "손 번갈아 사용하기", ageRange: "4단계", isCompleted: false, completedDate: nil, illustrationName: "Baby20"),
            GrowthMilestone(id: "milestone_3_2", title: "숨긴 물건 찾기", ageRange: "4단계", isCompleted: false, completedDate: nil, illustrationName: "Baby21"),
            GrowthMilestone(id: "milestone_3_3", title: " 자음 옹알이하기", ageRange: "4단계", isCompleted: false, completedDate: nil, illustrationName: "Baby22"),
            GrowthMilestone(id: "milestone_3_4", title: "손가락으로 과자 집기", ageRange: "4단계", isCompleted: false, completedDate: nil, illustrationName: "Baby23"),
            GrowthMilestone(id: "milestone_3_5", title: "부모 애착하기", ageRange: "4단계", isCompleted: false, completedDate: nil, illustrationName: "Baby24"),
        ],
        // 9~10개월
        [
            GrowthMilestone(id: "milestone_4_0", title: "배밀기", ageRange: "5단계", isCompleted: false, completedDate: nil, illustrationName: "Baby25"),
            GrowthMilestone(id: "milestone_4_1", title: "네발 기기", ageRange: "5단계", isCompleted: false, completedDate: nil, illustrationName: "Baby26"),
            GrowthMilestone(id: "milestone_4_2", title: "잡고 서기", ageRange: "5단계", isCompleted: false, completedDate: nil, illustrationName: "Baby27"),
            GrowthMilestone(id: "milestone_4_3", title: "작은 물건 잡기", ageRange: "5단계", isCompleted: false, completedDate: nil, illustrationName: "Baby28"),
            GrowthMilestone(id: "milestone_4_4", title: "행동 의사 표현하기", ageRange: "5단계", isCompleted: false, completedDate: nil, illustrationName: "Baby29"),
            GrowthMilestone(id: "milestone_4_5", title: "손가락으로 음식 먹기", ageRange: "5단계", isCompleted: false, completedDate: nil, illustrationName: "Baby30"),
        ],
        // 11~12개월
        [
            GrowthMilestone(id: "milestone_5_0", title: "걷기 시도하기", ageRange: "6단계", isCompleted: false, completedDate: nil, illustrationName: "Baby31"),
            GrowthMilestone(id: "milestone_5_1", title: "잡고 계단 오르기 시도", ageRange: "6단계", isCompleted: false, completedDate: nil, illustrationName: "Baby32"),
            GrowthMilestone(id: "milestone_5_2", title: "첫 단어 말하기", ageRange: "6단계", isCompleted: false, completedDate: nil, illustrationName: "Baby33"),
            GrowthMilestone(id: "milestone_5_3", title: "간단 지시 이해하기", ageRange: "6단계", isCompleted: false, completedDate: nil, illustrationName: "Baby34"),
            GrowthMilestone(id: "milestone_5_4", title: "스스로 컵 들고 마시기", ageRange: "6단계", isCompleted: false, completedDate: nil, illustrationName: "Baby35"),
            GrowthMilestone(id: "milestone_5_5", title: "부모 반응 살피기", ageRange: "6단계", isCompleted: false, completedDate: nil, illustrationName: "Baby36"),
        ],
        // 13~14개월
        [
            GrowthMilestone(id: "milestone_6_0", title: "혼자 걷기", ageRange: "7단계", isCompleted: false, completedDate: nil, illustrationName: "Baby37"),
            GrowthMilestone(id: "milestone_6_1", title: "물건 밀기", ageRange: "7단계", isCompleted: false, completedDate: nil, illustrationName: "Baby38"),
            GrowthMilestone(id: "milestone_6_2", title: "물건 끌기", ageRange: "7단계", isCompleted: false, completedDate: nil, illustrationName: "Baby39"),
            GrowthMilestone(id: "milestone_6_3", title: "흉내내기", ageRange: "7단계", isCompleted: false, completedDate: nil, illustrationName: "Baby40"),
            GrowthMilestone(id: "milestone_6_4", title: "숟가락 잡기", ageRange: "7단계", isCompleted: false, completedDate: nil, illustrationName: "Baby41"),
            GrowthMilestone(id: "milestone_6_5", title: "호기심", ageRange: "7단계", isCompleted: false, completedDate: nil, illustrationName: "Baby42"),
        ],
        // 15~16개월
        [
            GrowthMilestone(id: "milestone_7_0", title: "능숙하게 걷기", ageRange: "8단계", isCompleted: false, completedDate: nil, illustrationName: "Baby43"),
            GrowthMilestone(id: "milestone_7_1", title: "오르내리기", ageRange: "8단계", isCompleted: false, completedDate: nil, illustrationName: "Baby44"),
            GrowthMilestone(id: "milestone_7_2", title: "공_차기", ageRange: "8단계", isCompleted: false, completedDate: nil, illustrationName: "Baby45"),
            GrowthMilestone(id: "milestone_7_3", title: "고집_피우기", ageRange: "8단계", isCompleted: false, completedDate: nil, illustrationName: "Baby46"),
            GrowthMilestone(id: "milestone_7_4", title: "정리하기", ageRange: "8단계", isCompleted: false, completedDate: nil, illustrationName: "Baby47"),
            GrowthMilestone(id: "milestone_7_5", title: "치우기", ageRange: "8단계", isCompleted: false, completedDate: nil, illustrationName: "Baby48"),
        ],
        // 17~18개월
        [
            GrowthMilestone(id: "milestone_8_0", title: "살짝 뛰기", ageRange: "9단계", isCompleted: false, completedDate: nil, illustrationName: "Baby49"),
            GrowthMilestone(id: "milestone_8_1", title: "블록 쌓기", ageRange: "9단계", isCompleted: false, completedDate: nil, illustrationName: "Baby50"),
            GrowthMilestone(id: "milestone_8_2", title: "단어 조합하기", ageRange: "9단계", isCompleted: false, completedDate: nil, illustrationName: "Baby51"),
            GrowthMilestone(id: "milestone_8_3", title: "관심 갖기", ageRange: "9단계", isCompleted: false, completedDate: nil, illustrationName: "Baby52"),
            GrowthMilestone(id: "milestone_8_4", title: "혼자 손 씻기", ageRange: "9단계", isCompleted: false, completedDate: nil, illustrationName: "Baby53"),
            GrowthMilestone(id: "milestone_8_5", title: "혼자 옷 벗기", ageRange: "9단계", isCompleted: false, completedDate: nil, illustrationName: "Baby54"),
        ],
        // 19~20개월
        [
            GrowthMilestone(id: "milestone_9_0", title: "달리기 시도", ageRange: "10단계", isCompleted: false, completedDate: nil, illustrationName: "Baby55"),
            GrowthMilestone(id: "milestone_9_1", title: "공 던지기", ageRange: "10단계", isCompleted: false, completedDate: nil, illustrationName: "Baby56"),
            GrowthMilestone(id: "milestone_9_2", title: "선/점 그리기", ageRange: "10단계", isCompleted: false, completedDate: nil, illustrationName: "Baby57"),
            GrowthMilestone(id: "milestone_9_3", title: "질문하기", ageRange: "10단계", isCompleted: false, completedDate: nil, illustrationName: "Baby58"),
            GrowthMilestone(id: "milestone_9_4", title: "역할놀이", ageRange: "10단계", isCompleted: false, completedDate: nil, illustrationName: "Baby59"),
            GrowthMilestone(id: "milestone_9_5", title: "숟가락 사용하기", ageRange: "10단계", isCompleted: false, completedDate: nil, illustrationName: "Baby60"),
        ],
        // 21~22개월
        [
            GrowthMilestone(id: "milestone_10_0", title: "계단 오르기", ageRange: "11단계", isCompleted: false, completedDate: nil, illustrationName: "Baby61"),
            GrowthMilestone(id: "milestone_10_1", title: "공 위로 던지기", ageRange: "11단계", isCompleted: false, completedDate: nil, illustrationName: "Baby62"),
            GrowthMilestone(id: "milestone_10_2", title: "순서 따라하기", ageRange: "11단계", isCompleted: false, completedDate: nil, illustrationName: "Baby63"),
            GrowthMilestone(id: "milestone_10_3", title: "싫어 주장하기", ageRange: "11단계", isCompleted: false, completedDate: nil, illustrationName: "Baby64"),
            GrowthMilestone(id: "milestone_10_4", title: "좋아 주장하기", ageRange: "11단계", isCompleted: false, completedDate: nil, illustrationName: "Baby65"),
            GrowthMilestone(id: "milestone_10_5", title: "배변 신호 인식", ageRange: "11단계", isCompleted: false, completedDate: nil, illustrationName: "Baby66"),
        ],
        // 23~24개월
        [
            GrowthMilestone(id: "milestone_11_0", title: "안정적 달리기", ageRange: "12단계", isCompleted: false, completedDate: nil, illustrationName: "Baby67"),
            GrowthMilestone(id: "milestone_11_1", title: "점프 시도하기", ageRange: "12단계", isCompleted: false, completedDate: nil, illustrationName: "Baby68"),
            GrowthMilestone(id: "milestone_11_2", title: "대명사 사용하기", ageRange: "12단계", isCompleted: false, completedDate: nil, illustrationName: "Baby69"),
            GrowthMilestone(id: "milestone_11_3", title: "원 그리기", ageRange: "12단계", isCompleted: false, completedDate: nil, illustrationName: "Baby70"),
            GrowthMilestone(id: "milestone_11_4", title: "간식 혼자 먹기", ageRange: "12단계", isCompleted: false, completedDate: nil, illustrationName: "Baby71"),
            GrowthMilestone(id: "milestone_11_5", title: "도구 혼자 사용하기", ageRange: "12단계", isCompleted: false, completedDate: nil, illustrationName: "Baby72"),
        ],
    ]
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


