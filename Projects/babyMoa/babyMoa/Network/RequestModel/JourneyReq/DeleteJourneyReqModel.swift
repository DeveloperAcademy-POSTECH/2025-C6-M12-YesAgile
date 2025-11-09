//
//  DeleteJourneyReqModel.swift
//  babyMoa
//
//  Created by pherd on 11/8/25.
// Todo 추가해야함 Endpoint 및 service
struct DeleteJourneyReqModel: Encodable {
    var babyId: Int
    var journeyId: Int
}
