//
//  GetBabyResModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import Foundation

struct GetBabyResModel: Decodable {
    var id: Int
    var alias: String
    var name: String
    var birthDate: Date
    var gender: String
    var avatarImageName: String
    var relationshipType: String
}
