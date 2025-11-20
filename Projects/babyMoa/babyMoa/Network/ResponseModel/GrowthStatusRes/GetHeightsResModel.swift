//
//  GetHeightsResModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
// GET / array<object> 배열 체크 필요
struct GetHeightsResModel: Decodable {
    var height: Double
    var date: String
    var memo: String? // memo 필드 추가
}

// [GetHeightsResModel]
