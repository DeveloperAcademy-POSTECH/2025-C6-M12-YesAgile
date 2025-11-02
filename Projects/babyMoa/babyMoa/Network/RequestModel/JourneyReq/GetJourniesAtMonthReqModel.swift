//
//  GetJourniesAtMonthReqModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
//
struct GetJourniesAtMonthReqModel: Encodable {
    var babyId: Int
    var year: Int
    var month: Int
}
