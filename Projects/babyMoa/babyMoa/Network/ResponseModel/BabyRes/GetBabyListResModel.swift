//
//  GetBabyListResModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
//
// array<object>
// GET
struct GetBabyListResModel: Decodable {
    var id : Int
    var name : String
    var profileImageUrl : String
}
