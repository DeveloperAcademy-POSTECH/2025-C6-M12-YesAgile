//
//  GuardianCodeModel.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import Foundation

struct GuardianInvitate: Codable {
    let id: String
    let code: String
    let babyName: String
    let babyBirthday: Date
    let babyId: String
    let relationship: String
}

extension GuardianInvitate {
    
    static var mockGuardianInvitateModel: [GuardianInvitate] = [
        
        GuardianInvitate(
            id: UUID().uuidString,
            code: "A4B9KA4B9K2A4B9",
            babyName: "정우성", 
            babyBirthday: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
            babyId: "baby_id_001",
            relationship: "아빠"
        ),
    ]
}
