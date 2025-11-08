//
//  AddBabyViewModel.swift
//  babyMoa
//
//  Created by Baba on 11/04/25.
//

import Foundation
import SwiftUI // For Image
import PhotosUI // For PhotosPickerItem

@MainActor
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
    @Published var showImageOptions: Bool = false
    @Published var showLibrary: Bool = false // 사진 선택기 표시 여부
    @Published var displayedProfileImage: Image? // 선택된 이미지를 저장할 변수
    @Published var profileImage: UIImage?


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
        // 수정 모드는 현재 로직에서 제외하고 생성 로직에 집중합니다.
        guard editingBaby == nil else {
            print("DEBUG: Updating baby... (not implemented)")
            return
        }
        
        Task {
            // 1. 아바타 이미지 준비 (Base64 인코딩)
            let avatarImageData: Data?
            if let userSelectedImage = self.profileImage {
                // 사용자가 이미지를 선택한 경우, 해당 이미지를 사용
                avatarImageData = userSelectedImage.jpegData(compressionQuality: 0.8)
            } else {
                // 사용자가 이미지를 선택하지 않은 경우, 기본 에셋 이미지를 사용
                avatarImageData = UIImage(named: "defaultAvata")?.jpegData(compressionQuality: 0.8)
            }
            
            guard let finalImageData = avatarImageData else {
                print("❌ 아기 등록 실패: 이미지 데이터를 생성할 수 없습니다.")
                return
            }
            
            let avatarImageName = finalImageData.base64EncodedString()
            
            // 2. 서버에 보낼 나머지 파라미터를 준비합니다.
            let genderToServer: String
            switch selectedGender {
            case "male": genderToServer = "M"
            case "female": genderToServer = "F"
            default: genderToServer = "N"
            }
            
            let relationshipToServer: String
            switch relationship {
            case .mom: relationshipToServer = "MOTHER"
            case .dad: relationshipToServer = "FATHER"
            }
            
            let birthDateString = DateFormatter.yyyyDashMMDashdd.string(from: birthDate)

            // 로그 추가: 서버에 보내는 파라미터 출력 (Base64 문자열은 너무 길어서 생략)
            print("DEBUG: Registering baby with parameters:")
            print("DEBUG: alias: \(babyNickname)")
            print("DEBUG: name: \(babyName)")
            print("DEBUG: birthDate: \(birthDateString)")
            print("DEBUG: gender: \(genderToServer)")
            print("DEBUG: avatarImageName: (Base64 data)")
            print("DEBUG: relationshipType: \(relationshipToServer)")
            
            // 3. 서버에 아기 등록을 요청합니다.
            let result = await BabyMoaService.shared.postRegisterBaby(
                alias: babyNickname,
                name: babyName,
                birthDate: birthDateString,
                gender: genderToServer,
                avatarImageName: avatarImageName,
                relationshipType: relationshipToServer
            )
            
            // 4. 결과를 처리합니다.
            switch result {
            case .success(let response):
                // 로그 추가: 성공 응답 출력
                print("✅ 아기 등록 성공: \(response)")
                // 등록 성공 후, 네비게이션 스택을 리셋하여 RootView에서 초기 경로를 다시 결정하도록 합니다.
                // (아기가 생겼으므로 메인 화면으로 이동하게 됩니다.)
                coordinator.paths.removeAll()
                
            case .failure(let error):
                // 로그 추가: 실패 에러 출력
                print("❌ 아기 등록 실패: \(error)")
                // TODO: 사용자에게 에러 알림을 표시합니다.
            }
        }
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
