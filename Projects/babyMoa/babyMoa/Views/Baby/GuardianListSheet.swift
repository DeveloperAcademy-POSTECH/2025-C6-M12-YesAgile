//
//  GuardianListSheet.swift
//  babyMoa
//
//  Created by pherd on 10/29/25.
//

import SwiftUI

struct GuardianListSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    // 양육자 목록 (임시 데이터)
    @State private var guardians: [(id: String, name: String, relationship: String, isCurrentUser: Bool)] = [
        (id: "1", name: "나", relationship: "아빠", isCurrentUser: true),
        (id: "2", name: "배우자", relationship: "엄마", isCurrentUser: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // 핸들바
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            // 양육자 리스트
            List {
                ForEach(guardians, id: \.id) { guardian in
                    guardianRow(guardian)
                        .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                        .listRowSeparator(.visible)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteGuardian(guardian)
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            // 하단 텍스트
            Text("가족 구성원")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("Font").opacity(0.6))
                .padding(.vertical, 16)
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .presentationDetents([.fraction(0.35)])
        .presentationDragIndicator(.hidden)
    }
    
    // MARK: - Guardian Row
    private func guardianRow(_ guardian: (id: String, name: String, relationship: String, isCurrentUser: Bool)) -> some View {
        HStack(spacing: 16) {
            // 프로필 이미지 (아기 일러스트)
            Image("baby_milestone_illustration")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color("MemoryLightPink"), lineWidth: 2)
                )
            
            // 관계
            Text(guardian.relationship)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color("Font"))
            
            Spacer()
            
            // 사용자 표시
            if guardian.isCurrentUser {
                Text("사용자")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("Font").opacity(0.5))
            }
        }
        .padding(.vertical, 4)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Delete Guardian
    private func deleteGuardian(_ guardian: (id: String, name: String, relationship: String, isCurrentUser: Bool)) {
        withAnimation {
            guardians.removeAll { $0.id == guardian.id }
        }
        print("🗑️ 양육자 삭제: \(guardian.relationship)")
        
        // TODO: 실제 백엔드 삭제 로직 구현
    }
}

#Preview {
    GuardianListSheet()
}

