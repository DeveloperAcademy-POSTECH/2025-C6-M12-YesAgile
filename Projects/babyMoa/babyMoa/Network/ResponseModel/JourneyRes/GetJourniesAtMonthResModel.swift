//
//  GetJourniesAtMonthResModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
// GET / array<object>
// ResponseModelable 사용예정 - 퍼드

import Foundation

struct GetJourniesAtMonthResModel: ResponseModelable {
    var journeyId: Int // 추가한 사항
    var journeyImageUrl: String
    var latitude: Double
    var longitude: Double
    var date: String // "2025-11-01"
    var memo: String
    // 테드가 추가해주신 부분. 앞으로 써야함.
    func toDomain() async -> Journey {
        let image = await ImageManager.shared.downloadImage(from: journeyImageUrl)
        return Journey(journeyId : journeyId,
                       journeyImage: image,
                       latitude: latitude,
                       longitude: longitude,
                       date: DateFormatter.yyyyDashMMDashdd.date(from: date)!,
                       memo: memo)
    }
}


