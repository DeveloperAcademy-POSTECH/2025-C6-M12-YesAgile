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
    case grandPa = "할아버지"
    case grandMam = "할머니"
    case another = "기타"
    var id: String { self.rawValue }
}

struct AddBabyNewYes: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - States
    @State private var profileImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var babyName: String = ""
    @State private var babyNickname: String = ""
    @State private var selectedGender: String = "" // "M", "F", "N"
    @State private var birthDate = Date()
    @State private var relationship: Mytype = .mom
    
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
                            placeholder: "응애자임",
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
            .navigationTitle("아기 정보 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { handleDelete() }) {
                        Image(systemName: "trash")
                            .foregroundColor(Color("Brand-50"))
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomButtons
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
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    // 기본 아기 일러스트 (Assets에 추가 필요)
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
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
                .background(Color(.systemGray6))
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
            
            HStack {
                Text(formatDate(birthDate))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("Font"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .overlay {
                DatePicker("", selection: $birthDate, displayedComponents: .date)
                    .labelsHidden()
                    .contentShape(Rectangle())
                    .opacity(0.011)
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
                ForEach(Mytype.allCases) { type in
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
    
    // MARK: - Bottom Buttons
    private var bottomButtons: some View {
        HStack(spacing: 12) {
            Button(action: { dismiss() }) {
                Text("취소")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("Font"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            
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
        }
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
        // UserDefaults에 아기 정보 저장
        let babyData: [String: Any] = [
            "name": babyName,
            "nickname": babyNickname,
            "gender": selectedGender,
            "birthDate": formatDate(birthDate),
            "relationship": relationship.rawValue
        ]
        
        UserDefaults.standard.set(babyData, forKey: "currentBaby")
        
        // 프로필 이미지 저장 (Base64)
        if let profileImage = profileImage,
           let imageData = profileImage.jpegData(compressionQuality: 0.8) {
            let base64String = imageData.base64EncodedString()
            UserDefaults.standard.set(base64String, forKey: "babyProfileImage")
        }
        
        print("✅ 아기 정보 저장 완료")
        print("📝 이름: \(babyName)")
        print("📝 태명: \(babyNickname)")
        print("📝 성별: \(selectedGender)")
        print("📝 출생일: \(formatDate(birthDate))")
        print("📝 관계: \(relationship.rawValue)")
        
        dismiss()
    }
    
    /// 삭제 처리
    private func handleDelete() {
        // TODO: 삭제 확인 다이얼로그 추가
        UserDefaults.standard.removeObject(forKey: "currentBaby")
        UserDefaults.standard.removeObject(forKey: "babyProfileImage")
        print("🗑️ 아기 정보 삭제 완료")
        dismiss()
    }
}

#Preview {
    AddBabyNewYes()
}
