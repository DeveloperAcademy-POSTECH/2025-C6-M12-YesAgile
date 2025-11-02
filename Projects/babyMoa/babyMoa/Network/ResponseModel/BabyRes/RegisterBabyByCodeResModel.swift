//
//  RegisterBabyByCodeResModel.swift
//  babyMoa
//
//  Created by pherd on 11/1/25.
//
struct RegisterBabyByCodeResModel: Decodable {
    var babyID: Int
    var alias: String
    var name: String
    var birthDate: String  // 형식 "2025-10-01"
    var gender: String
    var avatarImageName: String
}
