
//
//  BabyProfileCard.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//
// BabyProfileCard는 선택된 아기의 프로필 정보를 카드 형태로 보여주는 뷰입니다.


import SwiftUI

struct BabyProfileCard: View {
    
    var coordinator: BabyMoaCoordinator
    let baby: Babies
    
    private var ageText: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: baby.date, to: Date())
        if let month = components.month, month > 0 {
            return "\(month)개월 \(components.day ?? 0)일"
        } else if let day = components.day, day >= 0 {
            return "\(day)일"
        }
        return ""
    }

    var body: some View {
        VStack(spacing: 8){
            HStack(spacing: 15){
                // baby.image가 유효한 URL인지 확인하고 AsyncImage를 사용
                if let url = URL(string: baby.image) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // 로딩 중
                                .frame(width: 70, height: 70)
                        case .success(let image):
                            image // 로딩 성공
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Image("defaultAvata") // 로딩 실패 시 기본 이미지
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                } else {
                    // URL이 없으면 기본 이미지 표시
                    Image("defaultAvata")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                }
                
                VStack(alignment:.leading, spacing: 0){
                    HStack{
                        Text("\(baby.name)(\(baby.nickname))")
                            .font(.system(size: 16, weight: .bold))
                        Text(baby.gender)
                            .font(.system(size: 14, weight: .medium))
                            .frame(height: 25)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .overlay {
                                Capsule()
                                    .stroke(Color.gray90, lineWidth: 2)
                            }
                        
                    }
                    .padding(.bottom, 11)
                    Text(ageText)
                        .font(.system(size: 14, weight: .medium))
                        .padding(.bottom, 8)
                    
                    Text(baby.relationship)
                        .frame(height: 20)
                        .padding(.horizontal, 10)
                        .foregroundStyle(Color.brand50)
                        .font(.system(size: 11, weight: .medium))
                        .background(Color.brand40.opacity(0.1))
                        .clipShape(Capsule())
                    
                }
                Spacer()
                Button(action: {
                    let genderValue = baby.gender == "남아" ? "male" : "female"
                    let babyToEdit = AddBabyModel(
                        babyId: UUID(uuidString: baby.id) ?? UUID(),
                        name: baby.name,
                        nickname: baby.nickname,
                        gender: genderValue,
                        birthDate: baby.date,
                        relationship: baby.relationship,
                        profileImage: baby.image,
                        isBorn: true
                    )
                    
                    coordinator.push(path: .addBabyStatus(baby: babyToEdit, isBorn: true))
                }, label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.gray40.opacity(0.3))
                        .font(.system(size: 17, weight: .semibold))
                    
                })
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray90, lineWidth: 1)
        }
    }
}


#Preview {
    let sampleImageUrl = "https://yesagile-s3-bucket.s3.amazonaws.com/avatars/2025/11/08/38d90084-0fcd-4f34-bc25-471dc2d2f704.jpg"
    
    return BabyProfileCard(coordinator: BabyMoaCoordinator(), baby: Babies(
        id: UUID().uuidString,
        image: sampleImageUrl,
        name: "김아기",
        nickname: "튼튼이",
        date: Date(),
        gender: "남아",
        relationship: "아빠"
    ))
}
