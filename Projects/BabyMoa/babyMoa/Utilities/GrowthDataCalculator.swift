//
//  GrowthDataCalculator.swift
//  babyMoa
//
//  Created by Baba on 11/13/25.
//

import Foundation

struct GrowthDataCalculator {

    /// 기록 날짜와 아기 생년월일을 기반으로 월령 레이블을 계산합니다.
    /// - Parameters:
    ///   - recordDate: 키/몸무게 기록이 측정된 날짜.
    ///   - birthDate: 아기의 생년월일.
    /// - Returns: "X개월 Y일" 형식의 문자열 또는 계산할 수 없는 경우 빈 문자열.
    static func calculateMonthLabel(recordDate: Date, birthDate: Date) -> String {
        let calendar = Calendar.current
        // 아기 생년월일과 기록 날짜 사이의 월(month)과 일(day) 구성 요소를 계산합니다.
        let components = calendar.dateComponents([.month, .day], from: birthDate, to: recordDate)
        
        let months = components.month ?? 0
        let days = components.day ?? 0
        
        if months < 0 || days < 0 { // 기록 날짜가 생년월일보다 이전인 경우
            return "0개월 0일"
        }
        
        return "\(months)개월 \(days)일"
    }

    /// 현재 값과 이전 값을 기반으로 차이 텍스트를 계산합니다. (성장만 표시)
    /// - Parameters:
    ///   - currentValue: 현재 키/몸무게 값.
    ///   - previousValue: 이전 키/몸무게 값 (선택 사항).
    /// - Returns: "+X.X" 형식의 문자열 (양수 차이만) 또는 차이가 없거나 감소한 경우 nil.
    static func calculateDiffText(currentValue: Double, previousValue: Double?) -> String? {
        guard let previousValue = previousValue else { return nil }
        let diff = currentValue - previousValue
        
        if diff > 0 {
            return String(format: "+%.1f", diff) // 양수 차이만 표시
        } else {
            return nil // 차이가 없거나 감소한 경우 nil 반환
        }
    }
}
