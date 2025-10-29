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
    @State private var currentBaby: Baby?
    
    // UserDefaults에서 아기 정보 로드
    @State private var babyName: String?
    @State private var babyNickname: String?
    @State private var dDay: String = ""
    @State private var guardianCount: Int = 1
    @State private var profileImage: UIImage?
    @State private var profileImageName: String?
    @State private var gender: Baby.Gender = .notSpecified
    
    var body: some View {
        VStack(spacing: 0) {
            // GrowthBabyHeader (공통 헤더)
            GrowthBabyHeader(showBabySelection: $showBabySelection)
            
           
            
            // 아기 프로필 카드
            BabyProfileCard(
                babyName: babyName,
                babyNickname: babyNickname,
                ageText: dDay,
                guardianCount: guardianCount,
                gender: gender,
                profileImage: profileImage,
                profileImageName: profileImageName
            )
            .padding(.horizontal, 20)
            
            // 메뉴 버튼들
            VStack(spacing: 12) {
                Button(action: { handleEditBaby() }) {
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
            .padding(.top, 24)
            
            Spacer()
        }
        .background(Color("Background"))
        .onAppear {
            loadBabyInfo()
        }
        .sheet(isPresented: $showBabyEdit) {
            AddBabyView()
        }
        .sheet(isPresented: $showBabyEditSheet) {
            if let baby = currentBaby {
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
        } onDismiss: {
            // 편집 완료 후 데이터 다시 로드
            loadBabyInfo()
        }
    }
    
    // MARK: - Menu Button
    private func menuButton(title: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color("Brand-50"))
            .cornerRadius(12)
    }
    
    // MARK: - Handle Edit Baby
    private func handleEditBaby() {
        // 현재 아기 데이터 로드
        guard let data = UserDefaults.standard.data(forKey: "currentBaby"),
              let baby = try? JSONDecoder().decode(Baby.self, from: data) else {
            print("⚠️ BabyView: 편집할 아기 정보가 없습니다")
            return
        }
        
        currentBaby = baby
        showBabyEditSheet = true
        
        print("✏️ 아기 정보 편집 시작")
    }
    
    // MARK: - Load Baby Info
    private func loadBabyInfo() {
        // Baby 모델로부터 데이터 로드
        guard let data = UserDefaults.standard.data(forKey: "currentBaby"),
              let baby = try? JSONDecoder().decode(Baby.self, from: data) else {
            print("⚠️ BabyView: 아기 정보가 없습니다")
            return
        }
        
        // 0. currentBaby 저장 (편집 기능에 필요)
        currentBaby = baby
        
        // 1. 이름과 태명 로드
        babyName = baby.name
        babyNickname = baby.nickname
        gender = baby.gender
        
        // 2. D-day 또는 나이 계산
        let isPregnant = baby.isPregnant ?? false
        if isPregnant {
            // 임신 중 (태명 등록): D-day 계산
            dDay = calculateDDay(from: baby.birthDate)
        } else {
            // 출생 후 (이름 등록): 개월수 계산
            dDay = calculateAge(from: baby.birthDate)
        }
        
        // 3. 프로필 이미지 로드
        loadProfileImage()
        
        print("✅ BabyView: 아기 정보 로드 완료")
        print("📝 이름: \(babyName ?? "nil")")
        print("📝 태명: \(babyNickname ?? "nil")")
        print("📝 D-day/나이: \(dDay)")
        print("📝 성별: \(gender)")
    }
    
    /// 프로필 이미지 로드
    private func loadProfileImage() {
        // 1. Base64 이미지 (AddBabyNewYesView에서 저장)
        if let base64String = UserDefaults.standard.string(forKey: "babyProfileImage"),
           let imageData = Data(base64Encoded: base64String),
           let uiImage = UIImage(data: imageData) {
            profileImage = uiImage
            print("✅ BabyView: Base64 프로필 이미지 로드")
        }
        // 2. 기본 이미지 이름 (AddBabyNewNoView에서 저장)
        else if let imageName = UserDefaults.standard.string(forKey: "babyProfileImageName") {
            profileImageName = imageName
            print("✅ BabyView: 기본 프로필 이미지 로드 (\(imageName))")
        }
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
