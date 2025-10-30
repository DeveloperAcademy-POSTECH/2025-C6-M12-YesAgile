//
//  BabyView.swift
//  babyMoa
//
//  Created by pherd on 10/28/25.
//
//
import SwiftUI

// MARK: - Baby View (아기 정보 및 설정)

struct BabyView: View {
    @State private var showBabySelection = false
    @State private var showBabyEdit = false
    @State private var showBabyEditSheet = false
    @State private var showGuardianListSheet = false
    @State private var babies: [Baby] = []  // 전체 아기 목록
    @State private var selectedBaby: Baby?  // 편집할 아기
    @State private var guardianCount: Int = 1
    
    var body: some View {
        VStack(spacing: 0) {
            // GrowthBabyHeader (공통 헤더)
            GrowthBabyHeader(showBabySelection: $showBabySelection)
            
            ScrollView {
                VStack(spacing: 16) {
                    // 아기 카드 목록
                    if babies.isEmpty {
                        // 아기가 없을 때
                        VStack(spacing: 12) {
                            Text("등록된 아기가 없습니다")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            Button(action: { showBabyEdit = true }) {
                                Text("첫 아기 추가하기")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color("Orange-50"))
                            }
                        }
                        .frame(height: 100)
                        .padding(.horizontal, 20)
                    } else {
                        // 여러 아기 카드 표시
                        ForEach(babies) { baby in
                            BabyProfileCard(
                                babyName: baby.name,
                                babyNickname: baby.nickname,
                                ageText: calculateAgeText(for: baby),
                                guardianCount: guardianCount,
                                gender: baby.gender,
                                profileImage: loadProfileImage(for: baby),
                                profileImageName: baby.profileImage
                            )
                            .padding(.horizontal, 20)
                            .onTapGesture {
                                handleEditBaby(baby)
                            }
                        }
                    }
                    
                    // 메뉴 버튼들
                    VStack(spacing: 12) {
                        Button(action: { showGuardianListSheet = true }) {
                            menuButton(title: "양육자 편집")
                        }
                        
                        NavigationLink(destination: AllGuardiansView()) {
                            menuButton(title: "공동 양육자 초대")
                        }
                        
                        Button(action: { showBabyEdit = true }) {
                            menuButton(title: "아기 추가")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
                .padding(.top, 16)
            }
            
            Spacer()
        }
        .background(Color("Background"))
        .onAppear {
            loadBabyInfo()
        }
        .sheet(isPresented: $showBabyEdit, onDismiss: {
            // 아기 추가 후 데이터 다시 로드
            loadBabyInfo()
        }) {
            AddBabyView()
        }
        .sheet(isPresented: $showBabyEditSheet, onDismiss: {
            // 편집 완료 후 데이터 다시 로드
            loadBabyInfo()
        }) {
            if let baby = selectedBaby {
                if baby.isPregnant == true {
                    // 태명 등록 (임신 중)
                    NavigationStack {
                        AddBabyNewNoView(baby: baby)
                    }
                } else {
                    // 출생 등록
                    NavigationStack {
                        AddBabyNewYes(baby: baby)
                    }
                }
            }
        }
        .sheet(isPresented: $showGuardianListSheet) {
            GuardianListSheet()
        }
    }
    
    // MARK: - Menu Button
    private func menuButton(title: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color("Orange-50"))
            .cornerRadius(12)
    }
    
    // MARK: - Handle Edit Baby
    private func handleEditBaby(_ baby: Baby) {
        selectedBaby = baby
        showBabyEditSheet = true
        
        print("✏️ 아기 정보 편집 시작 (ID: \(baby.id))")
    }
    
    // MARK: - Load Baby Info
    private func loadBabyInfo() {
        // 1. babies 배열 로드
        var loadedBabies: [Baby] = []
        if let data = UserDefaults.standard.data(forKey: "babies"),
           let decoded = try? JSONDecoder().decode([Baby].self, from: data) {
            loadedBabies = decoded
        }
        
        // 2. 마이그레이션: currentBaby가 babies에 없으면 추가
        if let data = UserDefaults.standard.data(forKey: "currentBaby"),
           let currentBaby = try? JSONDecoder().decode(Baby.self, from: data) {
            
            // babies 배열에 currentBaby가 없으면 맨 앞에 추가
            if !loadedBabies.contains(where: { $0.id == currentBaby.id }) {
                loadedBabies.insert(currentBaby, at: 0)
                
                // babies 배열 저장
                if let encoded = try? JSONEncoder().encode(loadedBabies) {
                    UserDefaults.standard.set(encoded, forKey: "babies")
                }
                
                // selectedBabyId 설정 (없으면)
                if UserDefaults.standard.string(forKey: "selectedBabyId") == nil {
                    UserDefaults.standard.set(currentBaby.id, forKey: "selectedBabyId")
                }
                
                print("✅ 기존 아기를 babies 배열로 마이그레이션 완료 (ID: \(currentBaby.id))")
            }
        }
        
        babies = loadedBabies
        print("✅ BabyView: \(babies.count)명의 아기 로드 완료")
    }
    
    // MARK: - Helper Functions
    
    /// 아기별 나이/D-day 계산
    private func calculateAgeText(for baby: Baby) -> String {
        let isPregnant = baby.isPregnant ?? false
        if isPregnant {
            // 임신 중 (태명 등록): D-day 계산
            return calculateDDay(from: baby.birthDate)
        } else {
            // 출생 후 (이름 등록): 개월수 계산
            return calculateAge(from: baby.birthDate)
        }
    }
    
    /// 아기별 프로필 이미지 로드
    private func loadProfileImage(for baby: Baby) -> UIImage? {
        // Baby 모델의 profileImage 필드에서 파일명/Assets 이미지명 가져오기
        return ImageHelper.loadImage(fileName: baby.profileImage)
    }
    
    /// 출생 예정일로부터 D-day 계산 (임신 중)
    private func calculateDDay(from date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expected = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: today, to: expected)
        let daysLeft = components.day ?? 0
        
        if daysLeft > 0 {
            return "D-\(daysLeft)"
        } else if daysLeft == 0 {
            return "D-Day!"
        } else {
            // 출산일이 지났으면 개월수 계산으로 전환
            return calculateAge(from: date)
        }
    }
    
    /// 출생일로부터 나이 계산 (출생 후)
    private func calculateAge(from date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date, to: Date())
        
        let months = components.month ?? 0
        let days = components.day ?? 0
        
        return "\(months)개월 \(days)일"
    }
}

// MARK: - Placeholder Views (나중에 구현)

struct AllGuardiansView: View {
    var body: some View {
        Text("공동 양육자 초대")
            .navigationTitle("공동 양육자")
    }
}



#Preview {
    BabyView()
}
