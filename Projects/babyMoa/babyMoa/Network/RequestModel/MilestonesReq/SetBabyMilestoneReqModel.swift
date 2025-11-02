//
//  SetBabyMilestoneReqModel.swift
//  babyMoa
//
//  Created by pherd on 11/2/25.
// POST / Res 는 EmptyData로
struct SetBabyMilestoneReqModel: Encodable {
    var babyId: Int
    var milestoneIdx: Int
    var milestoneImage: String
    var date: String // "2025-11-01"
    var memo: String
}
