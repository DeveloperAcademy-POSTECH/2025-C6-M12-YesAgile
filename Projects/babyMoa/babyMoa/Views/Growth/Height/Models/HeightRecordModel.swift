//
//  HeightRecordModel.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import Foundation
import SwiftUI

struct HeightRecordModel: Identifiable {
    let id = UUID()
    let babyId: Int            // <-- 1. Int로 수정
    let monthLabel: String     // "13개월"
    let dateText: String       // "2025. 10. 21."
    let diffText: String?      // "+0.1" 또는 nil
    let valueText: String      // "73.1cm"
    let date: Date // New property
    let value: Double // New property

    // 2. init 메서드 수정
    init(babyId: Int, monthLabel: String, dateText: String, diffText: String?, valueText: String) {
        self.babyId = babyId // <-- 2. Int 타입으로 할당
        self.monthLabel = monthLabel
        self.dateText = dateText
        self.diffText = diffText
        self.valueText = valueText

        // Parse date
        self.date = DateFormatter.yyyyMMdd.date(from: dateText) ?? Date()
        
        // Parse value
        let cleanedValueText = valueText.replacingOccurrences(of: "cm", with: "").trimmingCharacters(in: .whitespaces)
        self.value = Double(cleanedValueText) ?? 0.0 // Fallback to 0.0 if parsing fails
    }
}


//MARK: - Mock Up data

extension HeightRecordModel {
    static let mockData: [HeightRecordModel] = [
        HeightRecordModel(babyId: 1, monthLabel: "13개월", dateText: "2025. 10. 21.", diffText: "+0.1", valueText: "73.1cm"),
        HeightRecordModel(babyId: 1, monthLabel: "13개월", dateText: "2025. 10. 20.", diffText: nil, valueText: "73cm"),
        HeightRecordModel(babyId: 1, monthLabel: "12개월", dateText: "2025. 09. 15.", diffText: "+0.3", valueText: "73cm"),
        HeightRecordModel(babyId: 1, monthLabel: "11개월", dateText: "2025. 08. 10.", diffText: "+0.5", valueText: "72.7cm"),
        HeightRecordModel(babyId: 1, monthLabel: "10개월", dateText: "2025. 07. 10.", diffText: nil, valueText: "72.2cm"),
        HeightRecordModel(babyId: 1, monthLabel: "9개월", dateText: "2025. 06. 10.", diffText: "+0.4", valueText: "71.8cm"),
        HeightRecordModel(babyId: 1, monthLabel: "8개월", dateText: "2025. 05. 10.", diffText: "+0.6", valueText: "71.4cm"),
        HeightRecordModel(babyId: 1, monthLabel: "7개월", dateText: "2025. 04. 10.", diffText: "+0.5", valueText: "70.8cm"),
        HeightRecordModel(babyId: 1, monthLabel: "6개월", dateText: "2025. 03. 10.", diffText: "+0.7", valueText: "70.3cm"),
        HeightRecordModel(babyId: 1, monthLabel: "5개월", dateText: "2025. 02. 10.", diffText: "+0.8", valueText: "69.6cm"),
        HeightRecordModel(babyId: 1, monthLabel: "4개월", dateText: "2025. 01. 10.", diffText: "+1.0", valueText: "68.8cm"),
        HeightRecordModel(babyId: 1, monthLabel: "4개월", dateText: "2025. 01. 02.", diffText: nil, valueText: "67.8cm"),
        HeightRecordModel(babyId: 1, monthLabel: "3개월", dateText: "2024. 12. 10.", diffText: "+1.2", valueText: "67.0cm"),
        HeightRecordModel(babyId: 1, monthLabel: "2개월", dateText: "2024. 11. 10.", diffText: "+1.5", valueText: "65.8cm"),
        HeightRecordModel(babyId: 1, monthLabel: "2개월", dateText: "2024. 11. 01.", diffText: "+1.1", valueText: "64.3cm"),
        HeightRecordModel(babyId: 1, monthLabel: "1개월", dateText: "2024. 10. 10.", diffText: nil, valueText: "63.2cm"),
        HeightRecordModel(babyId: 1, monthLabel: "1개월", dateText: "2024. 10. 01.", diffText: "+2.0", valueText: "62.5cm"),
        HeightRecordModel(babyId: 1, monthLabel: "0개월", dateText: "2024. 09. 15.", diffText: "+1.5", valueText: "60.5cm"),
        HeightRecordModel(babyId: 1, monthLabel: "0개월", dateText: "2024. 09. 05.", diffText: "+1.2", valueText: "59.0cm"),
        HeightRecordModel(babyId: 1, monthLabel: "0개월", dateText: "2024. 09. 01.", diffText: nil, valueText: "57.8cm") // 가장 오래된 데이터
    ]
}
