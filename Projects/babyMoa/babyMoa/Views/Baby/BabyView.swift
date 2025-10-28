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
    @State private var showSettings = false
    @State private var showBabyEdit = false
    @State private var showGuardianManagement = false
    @State private var showAllGuardians = false
    
    // UserDefaults에서 아기 정보 로드
    @State private var babyName: String?           // 이름 (출생 후)
    @State private var babyNickname: String?       // 태명
    @State private var displayName: String = ""    // 표시할 이름 (이름 > 태명 우선순위)
    @State private var dDay: String = ""           // D-day 또는 개월수
    @State private var guardianCount: Int = 1
    @State private var guardianNames: [String] = [] // 양육자 이름 목록
    @State private var profileImage: UIImage?
    @State private var profileImageName: String?
    @State private var relationship: String = "엄마" // 내 관계
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 헤더 (프로필 + 아기 이름 + 설정)
            topHeader
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
            
            // 아기 프로필 카드
            babyProfileCard
                .padding(.horizontal, 20)
            
            // 메뉴 버튼들
            VStack(spacing: 12) {
                NavigationLink(destination: GuardianManagementView()) {
                    menuButton(title: "양육자 편집")
                }
                
                NavigationLink(destination: AllGuardiansView()) {
                    menuButton(title: "공동 양육자 조대")
                }
                
                Button(action: { showBabyEdit = true }) {
                    menuButton(title: "아기 추가")
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            
            Spacer()
        }
        .background(Color("BackgroundPrimary"))
        .onAppear {
            loadBabyInfo()
        }
        .sheet(isPresented: $showBabyEdit) {
            AddBabyView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    // MARK: - Top Header
    private var topHeader: some View {
        HStack(spacing: 12) {
            // 프로필 이미지
            profileImageView(size: 50)
            
            // 아기 이름 + 드롭다운
            Button(action: { showBabySelection = true }) {
                HStack(spacing: 4) {
                    Text(displayName.isEmpty ? "아기 이름" : displayName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("TextPrimary"))
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("BrandPrimary"))
                }
            }
            
            Spacer()
            
            // 설정 버튼
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color("BrandPrimary"))
            }
        }
    }
    
    // MARK: - Baby Profile Card
    private var babyProfileCard: some View {
        HStack(spacing: 16) {
            // 왼쪽: 프로필 이미지
            profileImageView(size: 80)
            
            // 오른쪽: 정보
            VStack(alignment: .leading, spacing: 8) {
                // 이름 + 태명 (케이스 처리)
                nameAndNicknameView
                
                // D-day 또는 나이
                Text(dDay)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("TextPrimary").opacity(0.6))
                
                // 양육자 정보 + 뱃지
                guardianInfoView
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    // MARK: - Name and Nickname View (케이스 처리)
    private var nameAndNicknameView: some View {
        Group {
            if let name = babyName, !name.isEmpty, let nickname = babyNickname, !nickname.isEmpty {
                // 케이스 1: 이름 + 태명 모두 있음
                HStack(spacing: 6) {
                    Text(name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("TextPrimary"))
                    
                    Text("| \(nickname)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("TextPrimary").opacity(0.6))
                }
            } else if let name = babyName, !name.isEmpty {
                // 케이스 2: 이름만 있음
                Text(name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("TextPrimary"))
            } else if let nickname = babyNickname, !nickname.isEmpty {
                // 케이스 3: 태명만 있음
                Text(nickname)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("TextPrimary"))
            } else {
                // 케이스 4: 둘 다 없음 (기본값)
                Text("아기 이름")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("TextPrimary").opacity(0.4))
            }
        }
    }
    
    // MARK: - Guardian Info View
    private var guardianInfoView: some View {
        HStack(spacing: 8) {
            // 양육자 수
            Text("양육자 \(guardianCount)명")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("TextPrimary"))
            
            // 대표 양육자 2명만 표시
            ForEach(guardianNames.prefix(2), id: \.self) { guardianName in
                Text(guardianName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color("BrandPrimary"))
                    .cornerRadius(12)
            }
            
            // 3명 이상일 경우 "..." 표시
            if guardianCount > 2 {
                Text("...")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("TextPrimary").opacity(0.6))
            }
        }
    }
    
    // MARK: - Profile Image View
    private func profileImageView(size: CGFloat) -> some View {
        Group {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else if let imageName = profileImageName,
                      let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: "face.smiling")
                            .font(.system(size: size * 0.5))
                            .foregroundColor(.gray)
                    )
            }
        }
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 3)
        )
    }
    
    // MARK: - Menu Button
    private func menuButton(title: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color("BrandPrimary"))
            .cornerRadius(12)
    }
    
    // MARK: - Load Baby Info
    private func loadBabyInfo() {
        guard let babyData = UserDefaults.standard.dictionary(forKey: "currentBaby") else {
            print("⚠️ BabyView: 아기 정보가 없습니다")
            return
        }
        
        // 1. 이름과 태명 로드
        babyName = babyData["name"] as? String
        babyNickname = babyData["nickname"] as? String
        
        // 2. 표시할 이름 결정 (이름 > 태명 우선순위)
        if let name = babyName, !name.isEmpty {
            displayName = name
        } else if let nickname = babyNickname, !nickname.isEmpty {
            displayName = nickname
        } else {
            displayName = "아기 이름"
        }
        
        // 3. D-day 또는 나이 계산
        let isPregnant = babyData["isPregnant"] as? Bool ?? false
        if isPregnant {
            // 임신 중 (태명 등록): D-day 계산
            if let expectedDateString = babyData["expectedBirthDate"] as? String {
                dDay = calculateDDay(from: expectedDateString)
            }
        } else {
            // 출생 후 (이름 등록): 개월수 계산
            if let birthDateString = babyData["birthDate"] as? String {
                dDay = calculateAge(from: birthDateString)
            }
        }
        
        // 4. 관계 로드
        if let rel = babyData["relationship"] as? String {
            relationship = rel
            guardianNames = [rel] // 기본적으로 내 관계 추가
        }
        
        // 5. 프로필 이미지 로드
        loadProfileImage()
        
        print("✅ BabyView: 아기 정보 로드 완료")
        print("📝 이름: \(babyName ?? "nil")")
        print("📝 태명: \(babyNickname ?? "nil")")
        print("📝 표시명: \(displayName)")
        print("📝 D-day/나이: \(dDay)")
        print("📝 관계: \(relationship)")
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
    private func calculateDDay(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        guard let expectedDate = formatter.date(from: dateString) else {
            return "D-?"
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expected = calendar.startOfDay(for: expectedDate)
        
        let components = calendar.dateComponents([.day], from: today, to: expected)
        let daysLeft = components.day ?? 0
        
        if daysLeft > 0 {
            return "D-\(daysLeft)"
        } else if daysLeft == 0 {
            return "D-Day!"
        } else {
            // 출산일이 지났으면 개월수 계산으로 전환
            return calculateAge(from: dateString)
        }
    }
    
    /// 출생일로부터 나이 계산 (출생 후)
    private func calculateAge(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        guard let birthDate = formatter.date(from: dateString) else {
            return "0개월 0일"
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: birthDate, to: Date())
        
        let months = components.month ?? 0
        let days = components.day ?? 0
        
        return "\(months)개월 \(days)일"
    }
}

// MARK: - Placeholder Views (나중에 구현)

struct GuardianManagementView: View {
    var body: some View {
        Text("양육자 편집")
            .navigationTitle("양육자 편집")
    }
}

struct AllGuardiansView: View {
    var body: some View {
        Text("공동 양육자 조대")
            .navigationTitle("공동 양육자")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("설정")
            .navigationTitle("설정")
    }
}

#Preview {
    BabyView()
}
