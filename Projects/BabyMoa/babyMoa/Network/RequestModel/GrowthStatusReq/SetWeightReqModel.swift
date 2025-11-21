//
//  SetWeightReqModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
// POST / Res는 EmptyData로
struct SetWeightReqModel: Encodable {
    var babyId: Int
    var weight: Double
    var date: String  // "2025-11-01"
}
