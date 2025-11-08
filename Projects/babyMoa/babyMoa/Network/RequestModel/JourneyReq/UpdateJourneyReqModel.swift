//
//  UpdateJourneyReqModel.swift
//  babyMoa
//
//  Created by pherd on 11/8/25.
//
struct UpdateJourneyReqModel: Decodable {
    var babyId: Int
    var journeyId: Int
    var journeyImage: String
    var latitude: Double
    var longitude: Double
    var date: String  //"2025-11-08"
    var memo: String
}
