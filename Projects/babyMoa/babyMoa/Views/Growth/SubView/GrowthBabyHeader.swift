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
    
    @State private var babies: [Baby] = []
    @State private var currentBaby: Baby?
    @State private var localProfileImage: UIImage?
    @State private var showBabySelectionSheet = false

    init(showBabySelection: Binding<Bool>) {
        self._showBabySelection = showBabySelection
    }

    var body: some View {
        HStack(spacing: 12) {
            // 아기 프로필 이미지 (로컬 우선, 그 다음 URL)
            profileImageView
            
            // 아기 이름 + 드롭다운 버튼
            Button(action: {
                // babies가 2명 이상일 때만 선택 sheet 표시
                if babies.count > 1 {
                    showBabySelectionSheet = true
                }
            }) {
                HStack(spacing: 6) {
                    Text(displayName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("Font"))

                    // 2명 이상일 때만 드롭다운 아이콘 표시
                    if babies.count > 1 {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("Font"))
                    }
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
        .sheet(isPresented: $showBabySelectionSheet) {
            BabySelectionSheet(babies: babies, onSelect: { selectedBaby in
                handleBabySelection(selectedBaby)
            })
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
            if let baby = currentBaby,
               let profileImage = ImageHelper.loadImage(fileName: baby.profileImage) {
                // Baby 모델의 profileImage에서 로드 (파일 또는 Assets)
                Image(uiImage: profileImage)
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
        // 1. babies 배열 로드
        if let data = UserDefaults.standard.data(forKey: "babies"),
           let loadedBabies = try? JSONDecoder().decode([Baby].self, from: data) {
            babies = loadedBabies
            print("✅ GrowthBabyHeader: \(babies.count)명의 아기 로드")
        }
        
        // 2. 현재 선택된 아기 로드 (하위 호환)
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
    }
    
    /// 아기 선택 처리
    private func handleBabySelection(_ baby: Baby) {
        // 1. selectedBabyId 업데이트
        UserDefaults.standard.set(baby.id, forKey: "selectedBabyId")
        
        // 2. currentBaby 업데이트 (하위 호환)
        if let encoded = try? JSONEncoder().encode(baby) {
            UserDefaults.standard.set(encoded, forKey: "currentBaby")
        }
        
        // 3. 로컬 상태 업데이트
        currentBaby = baby
        
        // 4. 변경 사항 broadcast
        NotificationCenter.default.post(name: .babyDataDidChange, object: nil)
        
        print("✅ 아기 전환 완료: \(baby.name ?? baby.nickname) (ID: \(baby.id))")
    }
}

#Preview {
    GrowthBabyHeader(
        showBabySelection: .constant(false)
    )
}
