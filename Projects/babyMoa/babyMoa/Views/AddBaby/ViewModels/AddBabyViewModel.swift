//
//  AddBabyViewModel.swift
//  babyMoa
//
//  Created by Baba on 11/04/25.
//

import Foundation
import SwiftUI // For Image
import PhotosUI // For PhotosPickerItem

class AddBabyViewModel: ObservableObject {

    // MARK: - Baby Info
    @Published var babyName: String = ""
    @Published var babyNickname: String = ""
    @Published var selectedGender: String = "male" // Changed default to match Segment tags
    @Published var birthDate: Date = Date()
    @Published var relationship: RelationshipType = .mom // Assuming RelationshipType is defined and imported

    // MARK: - UI State
    @Published var isBorn: Bool = true // Moved from AddBabyStatusView
    @Published var showDatePicker: Bool = false
    @Published var showRelationshipPicker: Bool = false

    // MARK: - Photo Picker
    @Published var selectedPhotoItem: PhotosPickerItem? // Moved from AddBabyStatusView context
    @Published var profileImage: UIImage? // Moved from AddBabyStatusView context

    // MARK: - Static Data
    // Moved from AddBabyStatusView
    let genderSegments: [Segment] = [
        Segment(tag: "male", title: "남아"),
        Segment(tag: "female", title: "여아"),
        Segment(tag: "none", title: "미정")
    ]

    // MARK: - Computed Properties
    var birthDateLabel: String {
        // Assuming Date+Extensions.swift is available
        return isBorn ? birthDate.yyyyMMddKorean : "태어날 날짜" // Adjusted logic for birthDateLabel
    }

    var isFormValid: Bool {
        if isBorn {
            return !babyName.isEmpty
        } else {
            return !babyNickname.isEmpty
        }
    }

    // MARK: - AddBabyInvitationView 관련 (Keep existing)
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
    
    // TODO: PhotosPickerItem이 변경될 때 profileImage를 로드하는 로직 추가
    // func loadImage() async { ... }
}
