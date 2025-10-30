//
//  Date+Extensions.swift
//  babyMoa
//
//  Created by Baba on 10/30/25.
//

import Foundation

extension Date {
    /// Date를 "yyyy.MM.dd" 형식의 문자열로 변환합니다.
    var yyyyMMdd: String {
        return DateFormatter.yyyyMMdd.string(from: self)
    }
    
    /// Date를 "yyyy년 MM월 dd일" 형식의 문자열로 변환합니다.
    var yyyyMMddKorean: String {
        return DateFormatter.yyyyMMddKorean.string(from: self)
    }
}


extension DateFormatter {
    /// "yyyy.MM.dd" 형식을 위한 static, 재사용 가능한 DateFormatter
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        // 사용자의 지역 설정에 관계없이 항상 동일한 형식을 보장하기 위해 locale을 고정합니다.
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /// "yyyy년 MM월 dd일" 형식을 위한 static, 재사용 가능한 DateFormatter
    static let yyyyMMddKorean: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    /// 백엔드 통신용 "yyyy.MM.dd.HH.mm.ss" 형식을 위한 static, 재사용 가능한 DateFormatter
    static let backendDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd.HH.mm.ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
