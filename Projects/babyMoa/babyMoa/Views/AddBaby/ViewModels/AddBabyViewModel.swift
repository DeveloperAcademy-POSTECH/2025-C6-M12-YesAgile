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
        }
        else {
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
            
            switch baby.gender {
            case "M":
                self.selectedGender = "male"
            case "F":
                self.selectedGender = "female"
            default:
                self.selectedGender = "none"
            }
            
            self.birthDate = baby.birthDate
            self.isBorn = baby.isBorn
            // self.relationship = baby.relationship // RelationshipType으로 변환 필요
            
            // 이미지 로딩 로직 추가: 전달받은 이미지 URL을 사용하여 이미지 로드
            Task {
                await loadImage(from: baby.profileImage)
            }
            
            // Log received values in edit mode
            print("--- AddBabyViewModel Init (Edit Mode) ---")
            print("수신 태명 (babyNickname): \(self.babyNickname)")
            print("수신 성별 (selectedGender): \(self.selectedGender)")
            print("수신 날짜 (birthDate): \(self.birthDate)")
            print("수신 관계 (relationship): \(self.relationship)")
            print("수신 isBorn: \(self.isBorn)")
            print("----------------------------------------")

        } else if let isBorn = isBorn {
            // 생성 모드: isBorn 값으로 초기화
            self.isBorn = isBorn
            
            // Log received values in create mode
            print("--- AddBabyViewModel Init (Create Mode) ---")
            print("수신 태명 (babyNickname): \(self.babyNickname)")
            print("수신 성별 (selectedGender): \(self.selectedGender)")
            print("수신 날짜 (birthDate): \(self.birthDate)")
            print("수신 관계 (relationship): \(self.relationship)")
            print("수신 isBorn: \(self.isBorn)")
            print("----------------------------------------")
        }
    }

    // MARK: - CRUD Methods
    func save() {
        Task {
            if let editingBaby = editingBaby {
                // --- 수정 로직 ---
                print("➡️ [UPDATE] 아기 정보 수정을 시작합니다. babyId: \(editingBaby.babyId)")
                let avatarImageName: String?
                if let userSelectedImage = self.profileImage {
                    avatarImageName = ImageManager.shared.encodeToBase64(userSelectedImage)
                } else {
                    if let defaultImage = UIImage(named: "defaultAvata") {
                        avatarImageName = ImageManager.shared.encodeToBase64(defaultImage)
                    } else {
                        avatarImageName = nil
                    }
                }
                
                guard let finalAvatarImageName = avatarImageName else {
                    print("❌ 아기 수정 실패: 이미지 데이터를 생성할 수 없습니다.")
                    return
                }
                
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
                
                let result = await BabyMoaService.shared.updateBaby(
                    babyId: editingBaby.babyId,
                    alias: babyNickname,
                    name: babyName,
                    birthDate: birthDateString,
                    gender: genderToServer,
                    avatarImageName: finalAvatarImageName,
                    relationshipType: relationshipToServer
                )
                
                switch result {
                case .success:
                    print("✅ [UPDATE] 아기 정보 수정 성공")
                    coordinator.pop()
                case .failure(let error):
                    print("❌ [UPDATE] 아기 정보 수정 실패: \(error.localizedDescription)")
                }
                
            } else {
                // --- 생성 로직 ---
                print("➡️ [CREATE] 아기 등록을 시작합니다.")
                // 1. 아바타 이미지 준비 (Base64 인코딩)
                let avatarImageName: String?
                if let userSelectedImage = self.profileImage {
                    avatarImageName = ImageManager.shared.encodeToBase64(userSelectedImage)
                } else {
                    if let defaultImage = UIImage(named: "defaultAvata") {
                        avatarImageName = ImageManager.shared.encodeToBase64(defaultImage)
                    } else {
                        avatarImageName = nil
                    }
                }
                
                guard let finalAvatarImageName = avatarImageName else {
                    print("❌ 아기 등록 실패: 이미지 데이터를 생성할 수 없습니다.")
                    return
                }
                
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

                print("DEBUG: Registering baby with parameters:")
                print("DEBUG: alias: \(babyNickname), name: \(babyName), birthDate: \(birthDateString), gender: genderToServer, relationshipType: relationshipToServer")
                
                // 3. 서버에 아기 등록을 요청합니다.
                let result = await BabyMoaService.shared.postRegisterBaby(
                    alias: babyNickname,
                    name: babyName,
                    birthDate: birthDateString,
                    gender: genderToServer,
                    avatarImageName: finalAvatarImageName,
                    relationshipType: relationshipToServer
                )
                
                // 4. 결과를 처리합니다.
                switch result {
                case .success(let response):
                    print("✅ [CREATE] 아기 등록 성공: \(response)")
                    coordinator.paths.removeAll()
                    
                case .failure(let error):
                    print("❌ [CREATE] 아기 등록 실패: \(error)")
                }
            }
        }
    }

    func delete() {
        guard editingBaby != nil else { return }
        showDeleteConfirmation = true
    }
    
    func executeDelete() {
        Task {
            guard let babyToDelete = editingBaby else {
                print("Error: No baby selected for deletion.")
                return
            }
            
            let babyId = babyToDelete.babyId
            print("➡️ [DELETE] 아기 삭제를 시작합니다. babyId: \(babyId)")
            let result = await BabyMoaService.shared.deleteBaby(babyId: babyId)
            
            switch result {
            case .success:
                print("✅ [DELETE] 아기 삭제 성공. babyId: \(babyId)")
                // If the deleted baby was the currently selected one, clear it
                if SelectedBabyState.shared.baby?.babyId == babyId {
                    SelectedBabyState.shared.baby = nil
                }
                coordinator.popToRoot() // Go back to the root view after deletion
            case .failure(let error):
                print("❌ [DELETE] 아기 삭제 실패: \(error.localizedDescription)")
                // Optionally, show an error alert to the user
            }
        }
    }
    
    // TODO: PhotosPickerItem이 변경될 때 profileImage를 로드하는 로직 추가
    // func loadImage() async { ... }
    
    /// 이미지 URL로부터 이미지를 다운로드하여 뷰모델의 이미지 속성을 업데이트합니다.
    private func loadImage(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            print("❌ 이미지 로드 실패: 유효하지 않은 URL - \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.profileImage = uiImage
                    self.displayedProfileImage = Image(uiImage: uiImage)
                    print("✅ 이미지 로드 성공: \(urlString)")
                }
            }
            else {
                print("❌ 이미지 로드 실패: 데이터로부터 UIImage 생성 불가")
            }
        } catch {
            print("❌ 이미지 로드 실패: \(error.localizedDescription)")
        }
    }
}
