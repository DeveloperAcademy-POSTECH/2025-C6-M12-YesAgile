//
//  GetGrowthDataResModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
// toothStatus [] 배열 점검 필요
struct GetGrowthDataResModel: Decodable {
    var latestHeight: Double
    var latestHeightDate: String
    var latestWeight: Double
    var latestWeighDate: String
    var toothStatus: [Bool]
}
