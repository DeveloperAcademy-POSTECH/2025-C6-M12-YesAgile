//
//  RegisterBaby.swift
//  babyMoa
//
//  Created by pherd on 10/31/25.
//

struct RegisterBabyReqModel: Encodable {
    var alias : String
    var name : String
    var birthDate : String // 형식 "2025-10-01"
    var gender : String
    var avatarImageName : String
    var relationshipType : String
}
