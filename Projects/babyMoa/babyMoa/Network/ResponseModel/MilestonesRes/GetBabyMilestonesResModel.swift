//
//  GetBabyMilestonesResModel.swift
//  babyMoa
//
//  Created by pherd on 11/2/25.
// GET /array<object>
struct GetBabyMilestonesResModel: Decodable {
    var milestoneName: String
    var imageUrl: String
    var date: String
    var memo: String
}
