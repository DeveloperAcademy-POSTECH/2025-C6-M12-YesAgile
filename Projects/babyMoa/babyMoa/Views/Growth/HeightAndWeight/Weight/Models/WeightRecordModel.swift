//
//  WeightRecordModel.swift
//  BabyMoa
//
//  Created by Baba on 11/13/25.
//

import Foundation
import SwiftUI
       

/// 서버에서 받은 키 데이터(height, date, memo)를 기반으로
/// UI에서 쓰기 편하게 가공한 모델
struct WeightRecordModel: Identifiable, Codable, GrowthRecord {
    // MARK: - Identifiable
    let id = UUID()

    // MARK: - ✅ API 스키마와 일치하는 필드
    /// 키 값 (cm) - Swagger: height (number)
    let weight: Double

    /// 측정 날짜 (서버 원본 문자열) - Swagger: date (string, yyyy-MM-dd)
    let date: String

    /// 메모 - Swagger: memo (string)
    let memo: String?

    // MARK: - 🧮 UI / 부가 정보 (API에는 없음)
    /// "13개월" 같은 월 라벨 (생일 기반으로 ViewModel에서 채워 넣기)
    var monthLabel: String?

    /// 이전 기록과의 차이값 예: "+0.3"
    var diffText: String?
    
    // MARK: -  Protokoll: GrowthRecord
    /// GrowthRecord 프로토콜을 위한 단위 값
    var unit: String {
        return "kg"
    }

    // MARK: - 계산 프로퍼티 (UI에서 사용)

    /// 차트/계산용 값 (height와 동일)
    var value: Double {
        weight
    }

    /// "73.1cm" 같은 표시용 텍스트
    var valueText: String {
        "\(weight)kg"
    }

    /// 서버 날짜 문자열("yyyy-MM-dd") → Date
    var dateValue: Date {
        DateFormatter.yyyyDashMMDashdd.date(from: date) ?? Date() // Use the shared formatter
    }


    // MARK: - 초기화 (직접 사용할 때)
    init(
        weight: Double,
        date: String,
        memo: String? = nil,
        monthLabel: String? = nil,
        diffText: String? = nil
    ) {
        self.weight = weight
        self.date = date
        self.memo = memo
        self.monthLabel = monthLabel
        self.diffText = diffText
    }

    // MARK: - Codable에서 JSON ↔ Swift 매핑에 사용할 키
    enum CodingKeys: String, CodingKey {
        case weight
        case date
        case memo
        // monthLabel, diffText, id 등은 JSON과 매핑하지 않음 (UI 전용)
    }
}

extension WeightRecordModel {
    static let mockData: [WeightRecordModel] = [
        WeightRecordModel(
            weight: 9.7,
            date: "2025-10-21",
            memo: "13개월 첫 기록"
        ),
        WeightRecordModel(
            weight: 9.6,
            date: "2025-10-20",
            memo: nil
        ),
        WeightRecordModel(
            weight: 9.3,
            date: "2025-09-15",
            memo: "12개월 검진"
        ),
        WeightRecordModel(
            weight: 8.8,
            date: "2025-08-10",
            memo: "11개월"
        ),
        WeightRecordModel(
            weight: 8.3,
            date: "2025-07-10",
            memo: "10개월"
        ),
        WeightRecordModel(
            weight: 7.9,
            date: "2025-06-10",
            memo: "9개월"
        ),
        WeightRecordModel(
            weight: 7.5,
            date: "2025-05-10",
            memo: "8개월"
        ),
        WeightRecordModel(
            weight: 7.0,
            date: "2025-04-10",
            memo: "7개월"
        ),
        WeightRecordModel(
            weight: 6.5,
            date: "2025-03-10",
            memo: "6개월"
        ),
        WeightRecordModel(
            weight: 5.7,
            date: "2025-02-10",
            memo: "5개월"
        )
    ]
}
