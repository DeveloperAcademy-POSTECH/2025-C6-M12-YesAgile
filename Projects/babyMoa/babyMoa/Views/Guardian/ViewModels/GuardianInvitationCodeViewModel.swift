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

class GuardianInvitationCodeViewModel: ObservableObject {
    
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
                self?.selectedBabyImageURL = newBaby?.image
                self?.selectedBabyName = newBaby?.name
                self?.selectedBabyBirthDate = newBaby?.date
                print("GuardianInvitationCodeViewModel: Received updated baby - \(newBaby?.name ?? "nil")")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 함수 정의
    
    func generateInvitationCode() async {
        isLoading = true
        errorMessage = nil
        
        guard let babyName = selectedBabyName, let birthDate = selectedBabyBirthDate else {
            errorMessage = "아기 정보가 없습니다. 먼저 아기를 선택해주세요."
            isLoading = false
            return
        }
        
        guard let babyId = SelectedBabyState.shared.baby?.id else {
            errorMessage = "아기 정보가 올바르지 않습니다."
            isLoading = false
            return
        }

        let result = await BabyMoaService.shared.getBabyInviteCode(babyId: babyId)

        switch result {
        case .success(let response):
            // API 응답으로 받은 초대 코드를 안전하게 언래핑합니다.
            guard let inviteCode = response.data else {
                errorMessage = "초대 코드를 받지 못했습니다."
                isLoading = false
                return
            }

            // API 응답 성공 시, 받은 코드로 초대 객체 생성
            self.generatedInvitation = GuardianInvitate(
                id: UUID().uuidString, // 임시 ID, 필요 시 서버 응답값으로 교체
                code: inviteCode,
                babyName: babyName,
                babyBirthday: birthDate,
                babyId: babyId,
                relationship: self.relationship.rawValue
            )
            self.shouldNavigateToCodeView = true
            // 코디네이터를 통해 다음 화면으로 이동
            await self.coordinator.push(path: .guardiainCode)

        case .failure(let error):
            // API 응답 실패 시, 에러 메시지 설정
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



