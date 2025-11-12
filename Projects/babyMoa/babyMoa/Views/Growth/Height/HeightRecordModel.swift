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
    let monthLabel: String      // "13개월"
    let dateText: String        // "2025. 10. 21."
    let diffText: String?       // "+0.1" 또는 nil
    let valueText: String       // "73.1cm"
}




extension HeightRecordModel {
    static let mockData: [HeightRecordModel] = [
        HeightRecordModel(monthLabel: "13개월", dateText: "2025. 10. 21.", diffText: "+0.1", valueText: "73.1cm"),
        HeightRecordModel(monthLabel: "13개월", dateText: "2025. 10. 20.", diffText: nil, valueText: "73cm"),
        HeightRecordModel(monthLabel: "12개월", dateText: "2025. 09. 15.", diffText: "+0.3", valueText: "73cm"),
        HeightRecordModel(monthLabel: "11개월", dateText: "2025. 08. 10.", diffText: "+0.5", valueText: "72.7cm"),
        HeightRecordModel(monthLabel: "10개월", dateText: "2025. 07. 10.", diffText: nil, valueText: "72.2cm"),
        HeightRecordModel(monthLabel: "9개월", dateText: "2025. 06. 10.", diffText: "+0.4", valueText: "71.8cm"),
        HeightRecordModel(monthLabel: "8개월", dateText: "2025. 05. 10.", diffText: "+0.6", valueText: "71.4cm"),
        HeightRecordModel(monthLabel: "7개월", dateText: "2025. 04. 10.", diffText: "+0.5", valueText: "70.8cm"),
        HeightRecordModel(monthLabel: "6개월", dateText: "2025. 03. 10.", diffText: "+0.7", valueText: "70.3cm"),
        HeightRecordModel(monthLabel: "5개월", dateText: "2025. 02. 10.", diffText: "+0.8", valueText: "69.6cm")
    ]
}
