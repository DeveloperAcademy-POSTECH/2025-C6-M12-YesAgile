//
//  BabyProfileCard.swift
//  babyMoa
//
//  Created by pherd on 10/29/25.
//

import SwiftUI

struct BabyProfileCard: View {
    let babyName: String?
    let babyNickname: String?
    let ageText: String
    let guardianCount: Int
    let gender: Baby.Gender
    let profileImage: UIImage?
    let profileImageName: String?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // 본문: 좌측 이미지, 우측 텍스트
            HStack(alignment: .center, spacing: 16) {
                // 프로필 이미지 + 연핑크 링
                ProfileImageView(
                    profileImage: profileImage,
                    profileImageName: profileImageName,
                    size: 70
                )
                .overlay(
                    Circle()
                        .stroke(Color("MemoryLightPink"), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)

                // 텍스트 영역
                VStack(alignment: .leading, spacing: 6) {
                    // 이름 | 태명
                    BabyNameView(name: babyName, nickname: babyNickname)

                    // D-day 또는 나이
                    Text(ageText)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("Font"))

                    // 양육자 정보
                    Text("양육자 \(guardianCount)명")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("Font"))
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 100)

            // 성별 캡슐 뱃지 (우상단)
            GenderBadge(gender: gender)
                .padding(.top, 12)
                .padding(.trailing, 12)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        .frame(height: 100)
    }
}

