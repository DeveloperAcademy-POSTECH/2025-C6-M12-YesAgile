//
//  SetTeethStatusReqModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
// Res 모델은 EmptyData 사용
struct SetTeethStatusReqModel: Encodable {
    var babyId: Int
    var teethId: Int
    var date: String
    var deletion: Bool
}
