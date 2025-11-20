//
//  GetJourniesAtMonthResModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
// GET / array<object>
struct GetJourniesAtMonthResModel: Decodable {
    var journeyImageUrl: String
    var latitude: Double
    var longitude: Double
    var date: String // "2025-11-01"
    var memo: String
}
