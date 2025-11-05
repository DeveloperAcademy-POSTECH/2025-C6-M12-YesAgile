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
    
    @Published var guardianInvite: [GuardianInvitate] = []
    
    // MARK: - State Properties
    @Published var generatedInvitation: GuardianInvitate?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var shouldNavigateToCodeView: Bool = false
    
    // MARK: - Copy Logic Properties
    @Published var isCodeCopied: Bool = false
    
    // MARK: - Mock Data (for preview)
    @Published var babyName: String = "응애자일"
    @Published var birthDate: Date = Date()
    
    // MARK: - Computed Properties
    
    var birthDateLabel: String {
        birthDate.yyyyMMddKorean
    }
    // MARK: - Relationship Picker
    @Published var showRelationshipPicker: Bool = false
    @Published var relationship: RelationshipType = .dad
    
    // MARK: - 함수 정의
    
    func generateInvitationCode() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            
            self.generatedInvitation = GuardianInvitate(
                id: UUID().uuidString,
                code: "2025-ABCD-4404",
                babyName: babyName,
                babyBirthday: birthDate,
                babyId: UUID().uuidString,
                relationship: self.relationship.rawValue
            )
            self.shouldNavigateToCodeView = true
            
        } catch {
            errorMessage = "초대 코드 생성에 실패했습니다. 다시 시도해주세요."
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
