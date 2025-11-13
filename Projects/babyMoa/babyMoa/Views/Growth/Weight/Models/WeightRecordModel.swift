//
//  WeightRecordModel.swift
//  BabyMoa
//
//  Created by Baba on 11/12/25.
//

import Foundation
import SwiftUI

struct WeightRecordModel: Identifiable {
    let id = UUID()
    let babyId: Int
    let monthLabel: String    // "13개월"
    let dateText: String      // "2025. 10. 21."
    let diffText: String?     // "+0.1" 또는 nil
    let valueText: String     // "9.8kg" (몸무게로 수정)
    let date: Date
    let value: Double

    init(babyId: Int, monthLabel: String, dateText: String, diffText: String?, valueText: String) {
        self.babyId = babyId
        self.monthLabel = monthLabel
        self.dateText = dateText
        self.diffText = diffText
        self.valueText = valueText

        // Parse date
        self.date = DateFormatter.yyyyMMdd.date(from: dateText) ?? Date()
        
        // Parse value
        // 1. "cm" 대신 "kg"를 제거하도록 수정
        let cleanedValueText = valueText.replacingOccurrences(of: "kg", with: "").trimmingCharacters(in: .whitespaces)
        self.value = Double(cleanedValueText) ?? 0.0 // Fallback to 0.0 if parsing fails
    }
}


//MARK: - Mock Up data

extension WeightRecordModel {
    static let mockData: [WeightRecordModel] = [
        WeightRecordModel(babyId: 1, monthLabel: "13개월", dateText: "2025. 10. 21.", diffText: "+0.1", valueText: "9.8kg"),
        WeightRecordModel(babyId: 1, monthLabel: "13개월", dateText: "2025. 10. 20.", diffText: nil, valueText: "9.7kg"),
        WeightRecordModel(babyId: 1, monthLabel: "12개월", dateText: "2025. 09. 15.", diffText: "+0.2", valueText: "9.5kg"),
        WeightRecordModel(babyId: 1, monthLabel: "11개월", dateText: "2025. 08. 10.", diffText: "+0.3", valueText: "9.3kg"),
        WeightRecordModel(babyId: 1, monthLabel: "10개월", dateText: "2025. 07. 10.", diffText: nil, valueText: "9.0kg"),
        WeightRecordModel(babyId: 1, monthLabel: "9개월", dateText: "2025. 06. 10.", diffText: "+0.3", valueText: "8.8kg"),
        WeightRecordModel(babyId: 1, monthLabel: "8개월", dateText: "2025. 05. 10.", diffText: "+0.4", valueText: "8.5kg"),
        WeightRecordModel(babyId: 1, monthLabel: "7개월", dateText: "2025. 04. 10.", diffText: "+0.4", valueText: "8.1kg"),
        WeightRecordModel(babyId: 1, monthLabel: "6개월", dateText: "2025. 03. 10.", diffText: "+0.5", valueText: "7.7kg"),
        WeightRecordModel(babyId: 1, monthLabel: "5개월", dateText: "2025. 02. 10.", diffText: "+0.5", valueText: "7.2kg"),
        WeightRecordModel(babyId: 1, monthLabel: "4개월", dateText: "2025. 01. 10.", diffText: "+0.6", valueText: "6.7kg"),
        WeightRecordModel(babyId: 1, monthLabel: "4개월", dateText: "2025. 01. 02.", diffText: nil, valueText: "6.1kg"),
        WeightRecordModel(babyId: 1, monthLabel: "3개월", dateText: "2024. 12. 10.", diffText: "+0.7", valueText: "6.0kg"),
        WeightRecordModel(babyId: 1, monthLabel: "2개월", dateText: "2024. 11. 10.", diffText: "+0.8", valueText: "5.3kg"),
        WeightRecordModel(babyId: 1, monthLabel: "2개월", dateText: "2024. 11. 01.", diffText: "+0.7", valueText: "4.5kg"),
        WeightRecordModel(babyId: 1, monthLabel: "1개월", dateText: "2024. 10. 10.", diffText: nil, valueText: "3.8kg"),
        WeightRecordModel(babyId: 1, monthLabel: "1개월", dateText: "2024. 10. 01.", diffText: "+0.5", valueText: "3.6kg"),
        WeightRecordModel(babyId: 1, monthLabel: "0개월", dateText: "2024. 09. 15.", diffText: "+0.3", valueText: "3.1kg"),
        WeightRecordModel(babyId: 1, monthLabel: "0개월", dateText: "2024. 09. 05.", diffText: "+0.2", valueText: "2.8kg"),
        WeightRecordModel(babyId: 1, monthLabel: "0개월", dateText: "2024. 09. 01.", diffText: nil, valueText: "2.6kg") // 가장 오래된 데이터
    ]
}
