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
    
    // MARK: - Properties
    var coordinator: BabyMoaCoordinator
    var editingBaby: AddBabyModel? // 수정할 아기 모델

    // MARK: - Baby Info
    @Published var addBaby: [AddBabyModel] = []
    @Published var babyName: String = ""
    @Published var babyNickname: String = ""
    @Published var selectedGender: String = "male"
    @Published var birthDate: Date = Date()
    @Published var relationship: RelationshipType = .mom
    
    // MARK: - UI State
    @Published var isBorn: Bool = true
    @Published var showDatePicker: Bool = false
    @Published var showRelationshipPicker: Bool = false
    @Published var showDeleteConfirmation: Bool = false

    // MARK: - Photo Picker
    @Published var selectedPhotoItem: PhotosPickerItem?
    @Published var profileImage: UIImage? //

    // MARK: - Static Data
    let genderSegments: [Segment] = [
        Segment(tag: "male", title: "남아"),
        Segment(tag: "female", title: "여아"),
        Segment(tag: "none", title: "미정")
    ]

    // MARK: - Computed Properties
    var availableGenderSegments: [Segment] {
        if isBorn {
            return genderSegments.filter { $0.tag != "none" }
        } else {
            return genderSegments
        }
    }
    
    var birthDateLabel: String {
        return isBorn ? birthDate.yyyyMMddKorean : "태어날 날짜"
    }

    var navigationTitle: String {
        return editingBaby == nil ? "아기 정보 입력하기" : "아기 정보 수정"
    }

    var isFormValid: Bool {
        if isBorn {
            return !babyName.isEmpty
        } else {
            return !babyNickname.isEmpty
        }
    }

    // MARK: - Invitation Code
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

    // MARK: - Initializer
    init(coordinator: BabyMoaCoordinator, baby: AddBabyModel? = nil, isBorn: Bool? = nil) {
        self.coordinator = coordinator
        self.editingBaby = baby

        if let baby = baby {
            // 수정 모드: 전달받은 데이터로 속성 초기화
            self.babyName = baby.name
            self.babyNickname = baby.nickname ?? ""
            self.selectedGender = baby.gender
            self.birthDate = baby.birthDate
            self.isBorn = baby.isBorn
            // self.relationship = baby.relationship // RelationshipType으로 변환 필요
            // self.profileImage = ... // 이미지 로딩 필요
        } else if let isBorn = isBorn {
            // 생성 모드: isBorn 값으로 초기화
            self.isBorn = isBorn
        }
    }

    // MARK: - CRUD Methods
    func save() {
        if let _ = editingBaby {
            // 수정 로직
            print("DEBUG: Updating baby...")
        } else {
            // 생성 로직
            print("DEBUG: Creating new baby...")
        }
        // TODO: API 호출 후 화면 전환
        // coordinator.pop()
    }

    func delete() {
        guard editingBaby != nil else { return }
        showDeleteConfirmation = true
    }
    
    func executeDelete() {
        guard let _ = editingBaby else { return }
        // 삭제 로직
        print("DEBUG: Deleting baby...")
        // TODO: API 호출 후 화면 전환
        // coordinator.pop()
    }
    
    // TODO: PhotosPickerItem이 변경될 때 profileImage를 로드하는 로직 추가
    // func loadImage() async { ... }
}
