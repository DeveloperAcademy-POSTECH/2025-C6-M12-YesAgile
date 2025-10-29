//
//  AddBabyNewYes.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI
import PhotosUI

enum Mytype: String, CaseIterable, Identifiable {
    case dady = "아빠"
    case mom = "엄마"
    var id: String { self.rawValue }
}

struct AddBabyNewYes: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Mode & Data
    let isEditMode: Bool
    let baby: Baby?
    
    // MARK: - States
    @State private var profileImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var babyName: String
    @State private var babyNickname: String
    @State private var selectedGender: String // "M", "F", "N"
    @State private var birthDate: Date
    @State private var relationship: Mytype
    @State private var showDatePicker = false
    @State private var showRelationshipPicker = false
    
    // MARK: - Initializers
    
    /// 신규 등록 모드
    init() {
        self.isEditMode = false
        self.baby = nil
        self._babyName = State(initialValue: "")
        self._babyNickname = State(initialValue: "")
        self._selectedGender = State(initialValue: "")
        self._birthDate = State(initialValue: Date())
        self._relationship = State(initialValue: .mom)
    }
    
    /// 편집 모드
    init(baby: Baby) {
        self.isEditMode = true
        self.baby = baby
        self._babyName = State(initialValue: baby.name ?? "")
        self._babyNickname = State(initialValue: baby.nickname)
        self._selectedGender = State(initialValue: baby.gender.rawValue)
        self._birthDate = State(initialValue: baby.birthDate)
        self._relationship = State(initialValue: Mytype(rawValue: baby.relationship) ?? .mom)
        // TODO: profileImage 로드
    }
    
    // MARK: - Validation
    private var isFormValid: Bool {
        !babyName.isEmpty && !selectedGender.isEmpty
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // 프로필 사진
                    profilePhotoSection
                    
                    // 입력 필드들
                    VStack(alignment: .leading, spacing: 20) {
                        // 이름
                        inputField(
                            label: "이름",
                            placeholder: "이름을 입력해주세요",
                            text: $babyName
                        )
                        
                        // 태명
                        inputField(
                            label: "태명",
                            placeholder: "태명을 입력해주세요",
                            text: $babyNickname
                        )
                        
                        // 성별
                        genderSection
                        
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
            .navigationTitle(isEditMode ? "아기 정보 편집" : "아기 정보 입력")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isEditMode {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { handleDelete() }) {
                            Image(systemName: "trash")
                                .foregroundColor(Color("Brand-50"))
                        }
                    }
                }
            }
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
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = uiImage
                }
            }
        }
    }
    
    // MARK: - Profile Photo Section
    private var profilePhotoSection: some View {
        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
            ZStack {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    // 기본 아기 일러스트 (Assets에 추가 필요)
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray.opacity(0.3))
                }
            }
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 4)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        }
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
    
    // MARK: - Gender Section
    private var genderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("성별")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("Font").opacity(0.6))
            
            HStack(spacing: 12) {
                genderButton(title: "남아", value: "M", color: Color("Brand-50"))
                genderButton(title: "여아", value: "F", color: Color("MemoryPink"))
            }
        }
    }
    
    private func genderButton(title: String, value: String, color: Color) -> some View {
        Button(action: { selectedGender = value }) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(selectedGender == value ? .white : color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(selectedGender == value ? color : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: 1.5)
                )
                .cornerRadius(8)
        }
    }
    
    // MARK: - Birth Date Section
    private var birthDateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("출생일")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("Font").opacity(0.6))
            
            Button(action: { showDatePicker = true }) {
                HStack {
                    Text(formatDate(birthDate))
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
                DatePicker("", selection: $birthDate, displayedComponents: .date)
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
                    ForEach(Mytype.allCases) { type in
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
        if isEditMode {
            // 편집 모드: 기존 아기 정보 업데이트
            print("✅ 아기 정보 수정 완료 (ID: \(baby?.id ?? "unknown"))")
            // TODO: API 호출하여 서버에 업데이트
        } else {
            // 신규 등록 모드 - Baby 모델 사용
            let newBaby = Baby(
                gender: Baby.Gender(rawValue: selectedGender) ?? .notSpecified,
                name: babyName.isEmpty ? nil : babyName,
                nickname: babyNickname,
                birthDate: birthDate,
                relationship: relationship.rawValue,
                isPregnant: false
            )
            
            // Baby 모델을 JSON으로 인코딩하여 저장
            if let encoded = try? JSONEncoder().encode(newBaby) {
                UserDefaults.standard.set(encoded, forKey: "currentBaby")
                print("✅ Baby 모델 저장 완료")
            }
            
            // 프로필 이미지 저장 (Base64)
            if let profileImage = profileImage,
               let imageData = profileImage.jpegData(compressionQuality: 0.8) {
                let base64String = imageData.base64EncodedString()
                UserDefaults.standard.set(base64String, forKey: "babyProfileImage")
            }
        }
        
        print("📝 이름: \(babyName)")
        print("📝 태명: \(babyNickname)")
        print("📝 성별: \(selectedGender)")
        print("📝 출생일: \(formatDate(birthDate))")
        print("📝 관계: \(relationship.rawValue)")
        
        dismiss()
    }
    
    /// 삭제 처리 -> 나중에 편집시에 재활용 가능하게
    private func handleDelete() {
        // TODO: 삭제 확인 다이얼로그 추가
        UserDefaults.standard.removeObject(forKey: "currentBaby")
        UserDefaults.standard.removeObject(forKey: "babyProfileImage")
        print("🗑️ 아기 정보 삭제 완료")
        dismiss()
    }
}

#Preview("신규 등록") {
    NavigationStack {
        AddBabyNewYes()
    }
}

#Preview("편집 모드") {
    NavigationStack {
        AddBabyNewYes(baby: Baby(
            id: "test",
            gender: .male,
            name: "응애",
            nickname: "응애자일",
            birthDate: Date(),
            relationship: "엄마"
        ))
    }
}
