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
    let babyName: String
    let babyProfileImage: String?
    
    @State private var localProfileImage: UIImage?

    init(
        showBabySelection: Binding<Bool>,
        babyName: String = "아기 이름",
        babyProfileImage: String? = nil
    ) {
        self._showBabySelection = showBabySelection
        self.babyName = babyName
        self.babyProfileImage = babyProfileImage
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
                    Text(babyName)
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
            loadLocalProfileImage()
        }
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
            } else if let profileImageName = UserDefaults.standard.string(forKey: "babyProfileImageName"),
                      let uiImage = UIImage(named: profileImageName) {
                // 기본 프로필 이미지 (AddBabyNewNoView에서 저장)
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            } else if let imageURL = babyProfileImage, !imageURL.isEmpty {
                // 백엔드에서 받은 URL 이미지
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    defaultProfileImage
                }
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
    
    /// UserDefaults에서 프로필 이미지 로드
    /// 우선순위:
    /// 1. Base64 이미지 (AddBabyNewYesView에서 저장한 실제 사진)
    /// 2. 기본 프로필 이름 (AddBabyNewNoView에서 저장한 기본 이미지)
    /// 3. URL 이미지 (백엔드)
    /// 4. 기본 아이콘
    private func loadLocalProfileImage() {
        if let base64String = UserDefaults.standard.string(forKey: "babyProfileImage"),
           let imageData = Data(base64Encoded: base64String),
           let uiImage = UIImage(data: imageData) {
            localProfileImage = uiImage
            print("✅ 로컬 프로필 이미지 로드 성공 (Base64)")
        } else {
            print("ℹ️ Base64 이미지 없음, 기본 프로필 이미지 확인 중...")
        }
    }
}

#Preview {
    GrowthBabyHeader(
        showBabySelection: .constant(false)
    )
}
