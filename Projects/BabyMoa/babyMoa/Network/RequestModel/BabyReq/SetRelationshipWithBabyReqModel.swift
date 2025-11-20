//
//  SetRelationshipWithBabyReqModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
// Res 모델은 EmptyData 사용  -> 점검해야함

struct SetRelationshipWithBabyReqModel: Encodable {
    var babyId: Int
    var relationshipType: String
}
