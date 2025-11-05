//
//  AddBabyViewModel.swift
//  babyMoa
//
//  Created by Baba on 11/04/25.
//

import Foundation

class AddBabyViewModel: ObservableObject {
    
    @Published var babyName: String = ""
    @Published var babyNickname: String = ""
    @Published var selectedGender: String = "MALE"
    @Published var birthDate: Date = Date()
    @Published var showDatePicker: Bool = false
    @Published var relationship: RelationshipType = .mom
    @Published var showRelationshipPicker: Bool = false
    
    var birthDateLabel: String {
        return birthDate.yyyyMMddKorean
    }
    //MARK: - AddBabyInvitationView 관련 
    @Published var invitationCode: String = "" {
            didSet {
                if invitationCode.count > 15 {
                    invitationCode = String(invitationCode.prefix(15))
                }
            }
        }

    var isInvitationCodeValid: Bool {
        invitationCode.count == 15
    }
}

