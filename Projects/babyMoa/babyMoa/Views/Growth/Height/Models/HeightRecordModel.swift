//
//  HeightRecordModel.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import Foundation
import SwiftUI

/// 서버에서 받은 키 데이터(height, date, memo)를 기반으로
/// UI에서 쓰기 편하게 가공한 모델
struct HeightRecordModel: Identifiable, Codable {
    // MARK: - Identifiable
    let id = UUID()

    // MARK: - ✅ API 스키마와 일치하는 필드
    /// 키 값 (cm) - Swagger: height (number)
    let height: Double

    /// 측정 날짜 (서버 원본 문자열) - Swagger: date (string, yyyy-MM-dd)
    let date: String

    /// 메모 - Swagger: memo (string)
    let memo: String?

    // MARK: - 🧮 UI / 부가 정보 (API에는 없음)
    /// "13개월" 같은 월 라벨 (생일 기반으로 ViewModel에서 채워 넣기)
    var monthLabel: String?

    /// 이전 기록과의 차이값 예: "+0.3"
    var diffText: String?

    // MARK: - 계산 프로퍼티 (UI에서 사용)

    /// 차트/계산용 값 (height와 동일)
    var value: Double {
        height
    }

    /// "73.1cm" 같은 표시용 텍스트
    var valueText: String {
        "\(height)cm"
    }

    /// 서버 날짜 문자열("yyyy-MM-dd") → Date
    var dateValue: Date {
        DateFormatter.yyyyDashMMDashdd.date(from: date) ?? Date() // Use the shared formatter
    }


    // MARK: - 초기화 (직접 사용할 때)
    init(
        height: Double,
        date: String,
        memo: String? = nil,
        monthLabel: String? = nil,
        diffText: String? = nil
    ) {
        self.height = height
        self.date = date
        self.memo = memo
        self.monthLabel = monthLabel
        self.diffText = diffText
    }

    // MARK: - Codable에서 JSON ↔ Swift 매핑에 사용할 키
    enum CodingKeys: String, CodingKey {
        case height
        case date
        case memo
        // monthLabel, diffText, id 등은 JSON과 매핑하지 않음 (UI 전용)
    }
}


extension HeightRecordModel {
    static let mockData: [HeightRecordModel] = [
        HeightRecordModel(
            height: 73.1,
            date: "2025-10-21",
            memo: "13개월 첫 기록",
            monthLabel: "13개월",
            diffText: "+0.1"
        ),
        HeightRecordModel(
            height: 73.0,
            date: "2025-10-20",
            memo: nil,
            monthLabel: "13개월",
            diffText: nil
        ),
        HeightRecordModel(
            height: 73.0,
            date: "2025-09-15",
            memo: "12개월 검진",
            monthLabel: "12개월",
            diffText: "+0.3"
        ),
        HeightRecordModel(
            height: 72.7,
            date: "2025-08-10",
            memo: "11개월",
            monthLabel: "11개월",
            diffText: "+0.5"
        ),
        HeightRecordModel(
            height: 72.2,
            date: "2025-07-10",
            memo: "10개월",
            monthLabel: "10개월",
            diffText: nil
        ),
        HeightRecordModel(
            height: 71.8,
            date: "2025-06-10",
            memo: "9개월",
            monthLabel: "9개월",
            diffText: "+0.4"
        ),
        HeightRecordModel(
            height: 71.4,
            date: "2025-05-10",
            memo: "8개월",
            monthLabel: "8개월",
            diffText: "+0.6"
        ),
        HeightRecordModel(
            height: 70.8,
            date: "2025-04-10",
            memo: "7개월",
            monthLabel: "7개월",
            diffText: "+0.5"
        ),
        HeightRecordModel(
            height: 70.3,
            date: "2025-03-10",
            memo: "6개월",
            monthLabel: "6개월",
            diffText: "+0.7"
        ),
        HeightRecordModel(
            height: 69.6,
            date: "2025-02-10",
            memo: "5개월",
            monthLabel: "5개월",
            diffText: "+0.8"
        )
    ]
}
