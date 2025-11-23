//
//  RelationshipType.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import Foundation

// 1. Codable 프로토콜을 추가합니다.
enum RelationshipType: String, CaseIterable, Identifiable, Codable {
    case mom = "엄마"
    case dad = "아빠"
    
    var id: String { self.rawValue } // UI에서 Identifiable로 사용
    
    var englishDescription: String {
        switch self {
        case .dad:
            return "FATHER"
        case .mom:
            return "MOTHER"
        }
    }

    // 서버 문자열로부터 RelationshipType을 생성하는 failable initializer 추가
    init?(serverString: String) {
        switch serverString {
        case "MOTHER":
            self = .mom
        case "FATHER":
            self = .dad
        default:
            return nil
        }
    }
    
    // 2. Decodable (서버 -> 앱)
    // 서버로부터 "MOTHER"라는 String을 받았을 때
    // 'self = .mom'으로 변환해주는 초기화 함수입니다.
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let serverString = try container.decode(String.self)

        switch serverString {
        case "MOTHER":
            self = .mom
        case "FATHER": // "아빠"에 해당하는 서버 값 (예상)
            self = .dad
        default:
            self = .mom
        }
    }
    
    // 3. Encodable (앱 -> 서버)
    // 'self'가 '.mom'일 때, "MOTHER"라는 String으로 변환하여
    // 서버(JSON)에 인코딩하는 함수입니다.
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let serverString: String

        switch self {
        case .mom:
            serverString = "MOTHER"
        case .dad:
            serverString = "FATHER" // "아빠"에 해당하는 서버 값 (예상)
       
        }
        
        try container.encode(serverString)
    }
}
