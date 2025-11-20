//
//  GetWeightsResModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
// GET / array<object> 
struct GetWeightsResModel : Decodable {
    var weight: Double
    var date: String // "2025-11-01"
    var memo: String?
}

