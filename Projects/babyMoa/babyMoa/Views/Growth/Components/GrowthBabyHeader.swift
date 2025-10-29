//
//  GrowthBabyHeader.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  아기 선택 헤더 컴포넌트
// 이거는 데이터 받아야겠지. 아기 데이터

import SwiftUI

struct GrowthBabyHeader: View {
    @Binding var showBabySelection: Bool
    
    @State private var currentBaby: Baby?
    @State private var localProfileImage: UIImage?

    init(showBabySelection: Binding<Bool>) {
        self._showBabySelection = showBabySelection
    }

    var body: some View {
        HStack(spacing: 12) {
            // 아기 프로필 이미지 (로컬 우선, 그 다음 URL)
            profileImageView
            
            // 아기 이름 + 드롭다운 버튼
            Button(action: {
                showBabySelection = true
            }) {
                HStack(spacing: 6) {
                    Text(displayName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("Font"))

                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("Font"))
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(red: 0.949, green: 0.949, blue: 0.965))
        .onAppear {
            loadBabyData()
        }
    }
    
    // MARK: - Computed Properties
    
    /// 표시할 이름 (이름 우선, 없으면 태명)
    private var displayName: String {
        if let baby = currentBaby {
            // 이름이 있으면 이름 표시 (AddBabyYesView - 출생한 아기)
            if let name = baby.name, !name.isEmpty {
                return name
            }
            // 이름이 없으면 태명 표시 (AddBabyNoView - 태명 등록)
            return baby.nickname
        }
        return "아기"
    }
    
    // MARK: - Profile Image View
    private var profileImageView: some View {
        Group {
            if let localProfileImage = localProfileImage {
                // UserDefaults에서 불러온 로컬 이미지 (AddBabyNewYesView에서 저장)
                Image(uiImage: localProfileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            } else if let baby = currentBaby,
                      let profileImageName = baby.profileImage,
                      let uiImage = UIImage(named: profileImageName) {
                // Baby 모델에 저장된 프로필 이미지 (태명 등록 시)
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            } else if let profileImageName = UserDefaults.standard.string(forKey: "babyProfileImageName"),
                      let uiImage = UIImage(named: profileImageName) {
                // 레거시: 별도 저장된 이미지명 (하위 호환)
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            } else {
                // 기본 이미지
                defaultProfileImage
            }
        }
    }

    private var defaultProfileImage: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 44, height: 44)
            .overlay(
                Image(systemName: "face.smiling")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
            )
    }
    
    // MARK: - Helper Functions
    
    /// UserDefaults에서 Baby 모델 및 프로필 이미지 로드
    private func loadBabyData() {
        // 1. Baby 모델 로드
        if let data = UserDefaults.standard.data(forKey: "currentBaby"),
           let baby = try? JSONDecoder().decode(Baby.self, from: data) {
            currentBaby = baby
            print("✅ Baby 모델 로드 성공")
            print("📝 이름: \(baby.name ?? "(없음)")")
            print("📝 태명: \(baby.nickname)")
            print("📝 임신 여부: \(baby.isPregnant ?? false)")
        } else {
            print("ℹ️ 저장된 아기 정보 없음")
        }
        
        // 2. 프로필 이미지 로드 (Base64)
        if let base64String = UserDefaults.standard.string(forKey: "babyProfileImage"),
           let imageData = Data(base64Encoded: base64String),
           let uiImage = UIImage(data: imageData) {
            localProfileImage = uiImage
            print("✅ 프로필 이미지 로드 성공 (Base64)")
        }
    }
}

#Preview {
    GrowthBabyHeader(
        showBabySelection: .constant(false)
    )
}
