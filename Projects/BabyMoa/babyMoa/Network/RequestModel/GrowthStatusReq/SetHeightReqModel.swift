//
//  SetHeightReqModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
// POST / Res는 EmptyData로 
struct SetHeightReqModel: Encodable {
    var babyId: Int
    var height: Double
    var data: String  //"2025-11-01"
}
