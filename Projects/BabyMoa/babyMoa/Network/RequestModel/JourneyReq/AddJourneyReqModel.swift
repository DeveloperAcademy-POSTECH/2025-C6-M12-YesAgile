//
//  AddJourneyReqModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
//  Post / Res EmptyData로
struct AddJourneyReqModel: Encodable {
    var babyId: Int
    var journeyImage: String
    var latitude: Double
    var longitude: Double
    var date: String // "2025-11-01"
    var memo : String
}
