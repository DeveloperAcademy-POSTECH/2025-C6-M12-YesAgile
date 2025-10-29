//
//  AddBabyNewNoView.swift
//  babyMoa
//
//  Created by pherd on 10/25/25.
//
// 프로필 고정으로 하기 아기로 

import SwiftUI

// 태명으로 아기 등록 시 관계 타입
private enum BabyRelationship: String, CaseIterable, Identifiable {
    case mom = "엄마"
    case dad = "아빠"
    case grandma = "할머니"
    case grandpa = "할아버지"
    case babysitter = "베이비시터"
    case familyMember = "가족 구성원"
    
    var id: String { self.rawValue }
}

// 기본 아기 프로필 이미지 (10개)
enum DefaultBabyProfile: String, CaseIterable, Identifiable {
    case profile1 = "baby_profile_1"
    case profile2 = "baby_profile_2"
    case profile3 = "baby_profile_3"
    case profile4 = "baby_profile_4"
    case profile5 = "baby_profile_5"
    case profile6 = "baby_profile_6"
    case profile7 = "baby_profile_7"
    case profile8 = "baby_profile_8"
    case profile9 = "baby_profile_9"
    case profile10 = "baby_profile_10"
    
    var id: String { self.rawValue }
    
    // Assets에 이미지가 없을 경우 임시 SF Symbol
    var systemImageFallback: String {
        switch self {
        case .profile1: return "face.smiling.fill"
        case .profile2: return "face.dashed.fill"
        case .profile3: return "figure.child"
        case .profile4: return "heart.fill"
        case .profile5: return "star.fill"
        case .profile6: return "moon.fill"
        case .profile7: return "sun.max.fill"
        case .profile8: return "cloud.fill"
        case .profile9: return "leaf.fill"
        case .profile10: return "snowflake"
        }
    }
}

struct AddBabyNewNoView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - States
    @State private var babyName: String = ""
    @State private var babyNickname: String = ""
    @State private var expectedBirthDate = Date()
    @State private var relationship: BabyRelationship = .mom
    @State private var showDatePicker = false
    @State private var showRelationshipPicker = false
    
    // 고정 프로필 이미지
    private let fixedProfileImage = "baby_milestone_illustration"
    
    // MARK: - Validation
    private var isFormValid: Bool {
        !babyNickname.isEmpty
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // 고정 프로필 이미지
                    profileImageView
                    
                    // 입력 필드들
                    VStack(alignment: .leading, spacing: 20) {
                        // 이름 (선택)
                        inputField(
                            label: "이름",
                            placeholder: "이름을 입력해주세요",
                            text: $babyName
                        )
                        
                        // 태명 (필수)
                        inputField(
                            label: "태명",
                            placeholder: "태명을 입력해주세요",
                            text: $babyNickname
                        )
                        
                        // 출생일
                        birthDateSection
                        
                        // 아이와 나의 관계
                        relationshipSection
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 80)
                }
                .padding(.top, 20)
            }
            .background(Color("Background"))
            .navigationTitle("아기 정보 입력")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                saveButton
            }
            .overlay {
                if showDatePicker {
                    centerDatePicker
                }
            }
            .overlay {
                if showRelationshipPicker {
                    centerRelationshipPicker
                }
            }
    }
    
    // MARK: - Fixed Profile Image
    private var profileImageView: some View {
        Image(fixedProfileImage)
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 4)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
    
    // MARK: - Input Field
    private func inputField(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("Font").opacity(0.6))
            
            TextField(placeholder, text: text)
                .font(.system(size: 16, weight: .medium))
                .padding()
                .background(Color("Gray-80"))
                .cornerRadius(8)
        }
    }
    
    // MARK: - Birth Date Section
    private var birthDateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("출생 예정일")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("Font").opacity(0.6))
            
            Button(action: { showDatePicker = true }) {
                HStack {
                    Text(formatDate(expectedBirthDate))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("Font"))
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(Color("Font").opacity(0.4))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color("Gray-80"))
                .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Relationship Section
    private var relationshipSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("아이와 나의 관계")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("Font").opacity(0.6))
            
            Button(action: { showRelationshipPicker = true }) {
                HStack {
                    Text(relationship.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("Font"))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("Font").opacity(0.4))
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: { handleSave() }) {
            Text("저장")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isFormValid ? Color("Brand-50") : Color.gray)
                .cornerRadius(12)
        }
        .disabled(!isFormValid)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color("Background"))
    }
    
    // MARK: - Center Pickers
    
    private var centerDatePicker: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    showDatePicker = false
                }
            
            VStack(spacing: 0) {
                DatePicker("", selection: $expectedBirthDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    private var centerRelationshipPicker: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    showRelationshipPicker = false
                }
            
            VStack(spacing: 0) {
                Picker("관계", selection: $relationship) {
                    ForEach(BabyRelationship.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 200)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal, 40)
                
                HStack(spacing: 0) {
                    Button("취소") {
                        showRelationshipPicker = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                    
                    Divider()
                        .frame(height: 44)
                    
                    Button("완료") {
                        showRelationshipPicker = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                    .foregroundColor(Color("Brand-50"))
                }
                .frame(height: 44)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal, 40)
                .padding(.top, 1)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /// 날짜 포맷팅 (2025.09.01 형식)
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    /// 저장 처리
    private func handleSave() {
        // UserDefaults에 아기 정보 저장
        let babyData: [String: Any] = [
            "name": babyName,
            "nickname": babyNickname,
            "expectedBirthDate": formatDate(expectedBirthDate),
            "relationship": relationship.rawValue,
            "profileImageName": fixedProfileImage,
            "isPregnant": true // 태명 등록이므로 임신 상태
        ]
        
        UserDefaults.standard.set(babyData, forKey: "currentBaby")
        UserDefaults.standard.set(fixedProfileImage, forKey: "babyProfileImageName")
        
        print("✅ 아기 정보 저장 완료 (태명)")
        print("📝 이름: \(babyName.isEmpty ? "(없음)" : babyName)")
        print("📝 태명: \(babyNickname)")
        print("📝 출생 예정일: \(formatDate(expectedBirthDate))")
        print("📝 관계: \(relationship.rawValue)")
        print("📝 프로필: \(fixedProfileImage)")
        
        dismiss()
    }
}

#Preview {
    AddBabyNewNoView()
}
