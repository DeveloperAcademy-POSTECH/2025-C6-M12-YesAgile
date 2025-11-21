//
//  GuardianCodeViewModel.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import Foundation
import Combine
import SwiftUI
import UIKit

class GuardianInvitationCodeViewModel: ObservableObject, Hashable {
    static func == (lhs: GuardianInvitationCodeViewModel, rhs: GuardianInvitationCodeViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    
    var coordinator: BabyMoaCoordinator
    
    @Published var guardianInvite: [GuardianInvitate] = []
    
    // MARK: - State Properties
    @Published var generatedInvitation: GuardianInvitate?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var shouldNavigateToCodeView: Bool = false
    
    // MARK: - Copy Logic Properties
    @Published var isCodeCopied: Bool = false
    
    // MARK: - Selected Baby Info from Shared State
    @Published var selectedBabyImageURL: String?
    @Published var selectedBabyName: String?
    @Published var selectedBabyBirthDate: Date?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    
    var birthDateLabel: String {
        selectedBabyBirthDate?.yyyyMMddKorean ?? "날짜 미정"
    }
    // MARK: - Relationship Picker
    @Published var showRelationshipPicker: Bool = false
    @Published var relationship: RelationshipType = .dad
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        
        // SelectedBabyState.shared의 baby 프로퍼티 변경을 구독합니다.
        SelectedBabyState.shared.$baby
            .receive(on: DispatchQueue.main) // UI 업데이트는 메인 스레드에서 수행합니다.
            .sink { [weak self] newBaby in
                // 공유된 아기 정보가 변경되면, 이 뷰모델의 관련 속성을 업데이트합니다.
                self?.selectedBabyImageURL = newBaby?.avatarImageName
                self?.selectedBabyName = newBaby?.name
                // `birthDate`가 String이므로 Date로 변환합니다.
                if let birthDateString = newBaby?.birthDate {
                    self?.selectedBabyBirthDate = DateFormatter.yyyyDashMMDashdd.date(from: birthDateString)
                }
                print("GuardianInvitationCodeViewModel: Received updated baby - \(newBaby?.name ?? "nil")")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 함수 정의
    
    @MainActor
    func generateInvitationCode() async {
        isLoading = true
        errorMessage = nil

        guard let baby = SelectedBabyState.shared.baby else {
            errorMessage = "아기 정보가 없습니다. 먼저 아기를 선택해주세요."
            isLoading = false
            return
        }

        let babyId = baby.babyId // Int 타입
        let babyName = baby.name

        // birthDate(String)를 Date로 변환
        guard let birthDate = DateFormatter.yyyyDashMMDashdd.date(from: baby.birthDate) else {
            errorMessage = "아기의 생년월일 형식이 올바르지 않습니다."
            isLoading = false
            return
        }

        let result = await BabyMoaService.shared.getBabyInviteCode(babyId: babyId)

        switch result {
        case .success(let response):
            print("Received invitation code response: \(response.data ?? "nil")")
            guard let inviteCode = response.data else {
                errorMessage = "초대 코드를 받지 못했습니다."
                isLoading = false
                return
            }

            self.generatedInvitation = GuardianInvitate(
                id: UUID().uuidString,
                code: inviteCode, // 직접 String 사용
                babyName: babyName,
                babyBirthday: birthDate,
                babyId: String(babyId), // GuardianInvitate는 String을 기대하므로 변환
                relationship: self.relationship.rawValue
            )
            self.shouldNavigateToCodeView = true
            await self.coordinator.push(path: .guardiainCode(viewModel: self))

        case .failure(let error):
            print("GuardianInvitationCodeViewModel API Error: \(error)")
            errorMessage = "초대 코드 생성에 실패했습니다: \(error.localizedDescription)"
        }

        isLoading = false
    }
    
    func copyCodeToClipboard() {
        guard let code = generatedInvitation?.code else { return }
        // UIKit을 사용하여 클립보드에 복사
#if canImport(UIKit)
        UIPasteboard.general.string = code
#endif
        withAnimation {
            isCodeCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.isCodeCopied = false
            }
        }
    }
    
}



