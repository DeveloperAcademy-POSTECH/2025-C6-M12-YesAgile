//
//  BabyModel.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//

import Foundation

// MARK: - Baby Models

/// 앱 내부에서 사용하는 Baby 모델 (Date 타입 사용)
struct Baby: Codable, Identifiable {
    let id: String
    var profileImage: String?          // 프로필 사진 URL 또는 로컬 이미지 이름
    var gender: Gender                 // 성별 (M/F/N)
    var name: String?                  // 이름 (출생 후)
    var nickname: String               // 태명
    var birthDate: Date                // 출생일 또는 출생 예정일
    var relationship: String           // 아이와의 관계
    var isPregnant: Bool?              // 임신 상태 여부 (태명 등록 시 true)
    
    enum Gender: String, Codable {
        case male = "M"
        case female = "F"
        case notSpecified = "N"
    }
    
    // MARK: - Computed Properties
    
    /// 아기 나이 (개월수)
    var ageInMonths: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: birthDate, to: Date())
        return components.month ?? 0
    }
    
    /// 아기 나이 (일수)
    var ageInDays: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: birthDate, to: Date())
        return components.day ?? 0
    }
    
    /// 출산일 표시용 (예: "2024년 10월 26일")
    var formattedBirthDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: birthDate)
    }
    
    /// 출산일 표시용 (예: "2024.10.26")
    var shortFormattedBirthDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: birthDate)
    }
    
    // MARK: - Custom Codable (백엔드 형식 변환)
    
    enum CodingKeys: String, CodingKey {
        case id, profileImage, gender, name, nickname, birthDate, relationship, isPregnant
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        gender = try container.decode(Gender.self, forKey: .gender)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        nickname = try container.decode(String.self, forKey: .nickname)
        relationship = try container.decode(String.self, forKey: .relationship)
        isPregnant = try container.decodeIfPresent(Bool.self, forKey: .isPregnant)
        
        // ✅ String → Date 변환 (백엔드 형식: "2024.10.26.14.30.00")
        let birthDateString = try container.decode(String.self, forKey: .birthDate)
        birthDate = Baby.dateFromBackendString(birthDateString) ?? Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(profileImage, forKey: .profileImage)
        try container.encode(gender, forKey: .gender)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(relationship, forKey: .relationship)
        try container.encodeIfPresent(isPregnant, forKey: .isPregnant)
        
        // ✅ Date → String 변환 (백엔드 형식: "2024.10.26.14.30.00")
        let birthDateString = Baby.backendStringFromDate(birthDate)
        try container.encode(birthDateString, forKey: .birthDate)
    }
    
    // MARK: - 일반 Initializer (앱 내부에서 사용)
    
    init(
        id: String = UUID().uuidString,
        profileImage: String? = nil,
        gender: Gender,
        name: String? = nil,
        nickname: String,
        birthDate: Date,
        relationship: String,
        isPregnant: Bool? = nil
    ) {
        self.id = id
        self.profileImage = profileImage
        self.gender = gender
        self.name = name
        self.nickname = nickname
        self.birthDate = birthDate
        self.relationship = relationship
        self.isPregnant = isPregnant
    }
    
    // MARK: - Date Conversion Helpers
    
    /// 백엔드 형식 String → Date 변환
    /// - Parameter string: "2025.10.24.11.40.20"
    /// - Returns: Date?
    static func dateFromBackendString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd.HH.mm.ss"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: string)
    }
    
    /// Date → 백엔드 형식 String 변환
    /// - Parameter date: Date
    /// - Returns: "2025.10.24.11.40.20"
    static func backendStringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd.HH.mm.ss"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
}

// MARK: - API Request Models (백엔드 통신용)

/// 아기 정보 추가 API 요청 모델
/// 백엔드 형식에 맞춘 String 타입 사용
struct CreateBabyRequest: Codable {
    let profileImage: String?       // 프로필 사진 URL 또는 Base64
    let gender: String              // "M", "F", "N"
    let name: String?               // 이름 (선택)
    let nickname: String            // 태명 (필수)
    let birthDate: String           // "2025.10.24.11.40.20" 형식
    let relationship: String        // 아이와의 관계
    let isPregnant: Bool?           // 임신 상태 (태명 등록 시 true)
    
    /// Baby 모델로부터 생성
    init(from baby: Baby) {
        self.profileImage = baby.profileImage
        self.gender = baby.gender.rawValue
        self.name = baby.name
        self.nickname = baby.nickname
        self.birthDate = Baby.backendStringFromDate(baby.birthDate)
        self.relationship = baby.relationship
        self.isPregnant = baby.isPregnant
    }
    
    /// 직접 생성 (앱에서 입력받은 데이터로)
    init(
        profileImage: String?,
        gender: String,
        name: String?,
        nickname: String,
        birthDate: Date,
        relationship: String,
        isPregnant: Bool? = nil
    ) {
        self.profileImage = profileImage
        self.gender = gender
        self.name = name
        self.nickname = nickname
        self.birthDate = Baby.backendStringFromDate(birthDate)
        self.relationship = relationship
        self.isPregnant = isPregnant
    }
}

/// 아기 정보 수정 API 요청 모델
struct UpdateBabyRequest: Codable {
    let babyId: String
    let profileImage: String?
    let gender: String?
    let name: String?
    let nickname: String?
    let birthDate: String?
    let relationship: String?
}

// MARK: - API Response Models

/// 아기 정보 추가/수정 응답 모델
struct CreateBabyResponse: Codable {
    let success: Bool
    let message: String?
    let data: BabyResponseData?
    
    struct BabyResponseData: Codable {
        let babyId: String
        let baby: Baby?
    }
}

/// 아기 목록 조회 응답 모델
struct GetBabiesResponse: Codable {
    let success: Bool
    let message: String?
    let data: [Baby]?
}

/// 단일 아기 조회 응답 모델
struct GetBabyResponse: Codable {
    let success: Bool
    let message: String?
    let data: Baby?
}

/// API 에러 응답 모델
struct APIError: Codable {
    let success: Bool
    let message: String
    let errorCode: String?
}


