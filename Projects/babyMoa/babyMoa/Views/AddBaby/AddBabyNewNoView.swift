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
    @State private var selectedProfileIndex: Int = 0
    @State private var babyName: String = ""
    @State private var babyNickname: String = ""
    @State private var expectedBirthDate = Date()
    @State private var relationship: BabyRelationship = .mom
    @State private var showDatePicker = false
    
    // 기본 프로필 이미지 배열
    private let defaultProfiles = DefaultBabyProfile.allCases
    
    // MARK: - Validation
    private var isFormValid: Bool {
        !babyNickname.isEmpty
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // 프로필 이미지 선택 (좌우 스와이프)
                    profileImageCarousel
                    
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
    }
    
    // MARK: - Profile Image Carousel
    private var profileImageCarousel: some View {
        VStack(spacing: 12) {
            TabView(selection: $selectedProfileIndex) {
                ForEach(0..<defaultProfiles.count, id: \.self) { index in
                    profileImageView(for: defaultProfiles[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 140)
            
            // 커스텀 페이지 인디케이터
            HStack(spacing: 6) {
                ForEach(0..<defaultProfiles.count, id: \.self) { index in
                    Circle()
                        .fill(selectedProfileIndex == index ? Color("Brand-50") : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedProfileIndex)
                }
            }
            
            Text("좌우로 스와이프하여 프로필을 선택하세요")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color("Font").opacity(0.5))
        }
    }
    
    private func profileImageView(for profile: DefaultBabyProfile) -> some View {
        ZStack {
            // Assets에 이미지가 있으면 사용, 없으면 SF Symbol
            if let uiImage = UIImage(named: profile.rawValue) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Image(systemName: profile.systemImageFallback)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("Brand-50"))
                    .frame(width: 100, height: 100)
                    .background(Color("Brand-50").opacity(0.1))
                    .clipShape(Circle())
            }
        }
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
                .background(Color(.systemGray6))
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
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker("출생 예정일 선택", selection: $expectedBirthDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                    
                    Button("완료") {
                        showDatePicker = false
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color("Brand-50"))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .presentationDetents([.height(450)])
            }
        }
    }
    
    // MARK: - Relationship Section
    private var relationshipSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("아이와 나의 관계")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("Font").opacity(0.6))
            
            Menu {
                ForEach(BabyRelationship.allCases) { type in
                    Button(type.rawValue) {
                        relationship = type
                    }
                }
            } label: {
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
    
    // MARK: - Helper Functions
    
    /// 날짜 포맷팅 (2025.09.01 형식)
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    /// 저장 처리
    private func handleSave() {
        // 선택된 프로필 이미지 이름
        let selectedProfileName = defaultProfiles[selectedProfileIndex].rawValue
        
        // UserDefaults에 아기 정보 저장
        let babyData: [String: Any] = [
            "name": babyName,
            "nickname": babyNickname,
            "expectedBirthDate": formatDate(expectedBirthDate),
            "relationship": relationship.rawValue,
            "profileImageName": selectedProfileName,
            "isPregnant": true // 태명 등록이므로 임신 상태
        ]
        
        UserDefaults.standard.set(babyData, forKey: "currentBaby")
        UserDefaults.standard.set(selectedProfileName, forKey: "babyProfileImageName")
        
        print("✅ 아기 정보 저장 완료 (태명)")
        print("📝 이름: \(babyName.isEmpty ? "(없음)" : babyName)")
        print("📝 태명: \(babyNickname)")
        print("📝 출생 예정일: \(formatDate(expectedBirthDate))")
        print("📝 관계: \(relationship.rawValue)")
        print("📝 프로필: \(selectedProfileName)")
        
        dismiss()
    }
}

#Preview {
    AddBabyNewNoView()
}
