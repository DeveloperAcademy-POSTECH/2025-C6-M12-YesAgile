//
//  GrowthViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI
import Combine

@Observable
final class GrowthViewModel {
    var coordinator: BabyMoaCoordinator
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    // 좌측 상단 아기 정보 보여주기 위함
    var selectedBaby: BabySummary?
    
    var latestHeight: Double?
    var latestWeight: Double?
    
    var selectedMonthIdx: Int = 0
    
    var selectedMilestoneAgeRangeIdx: Int = 0
    var selectedMilestoneIdxInAgeRange: Int = 0
    
    var isMilestoneEditingViewPresented: Bool = false
    
    // 마일스톤 데이터 더 추가 예정
    var allMilestones: [[GrowthMilestone]] = [
        // 0~2개월
        [
            GrowthMilestone(id: "milestone_0_0", title: "누워있기", ageRange: "0~2개월", isCompleted: false, completedDate: nil, illustrationName: "Baby01"), // illustrationName은 url 형식으로 올 수 있음
            GrowthMilestone(id: "milestone_0_1", title: "손발 움직이기", ageRange: "0~2개월", isCompleted: false, completedDate: nil, illustrationName: "Baby02"),
            GrowthMilestone(id: "milestone_0_2", title: "빛 반응하기", ageRange: "0~2개월", isCompleted: false, completedDate: nil, illustrationName: "Baby03"),
            GrowthMilestone(id: "milestone_0_3", title: "소리 반응하기", ageRange: "0~2개월", isCompleted: false, completedDate: nil, illustrationName: "Baby04"),
            GrowthMilestone(id: "milestone_0_4", title: "얼굴 인식하기", ageRange: "0~2개월", isCompleted: false, completedDate: nil, illustrationName: "Baby05"),
            GrowthMilestone(id: "milestone_0_5", title: "울기", ageRange: "0~2개월", isCompleted: false, completedDate: nil, illustrationName: "Baby06"),
        ],
        // 3~4개월
        [
            GrowthMilestone(id: "milestone_1_0", title: "목가누기", ageRange: "3~4개월", isCompleted: false, completedDate: nil, illustrationName: "Baby07"),
            GrowthMilestone(id: "milestone_1_1", title: "머리들기", ageRange: "3~4개월",isCompleted: false, completedDate: nil, illustrationName: "Baby08"),
            GrowthMilestone(id: "milestone_1_2", title: "물건 잡기", ageRange: "3~4개월", isCompleted: false, completedDate: nil, illustrationName: "Baby09"),
            GrowthMilestone(id: "milestone_1_3", title: "옹알이 시작하기", ageRange: "3~4개월",isCompleted: false, completedDate: nil, illustrationName: "Baby10"),
            GrowthMilestone(id: "milestone_1_4", title: "시선 이동하기", ageRange: "3~4개월",isCompleted: false, completedDate: nil, illustrationName: "Baby11"),
            GrowthMilestone(id: "milestone_1_5", title: "웃기", ageRange: "3~4개월",isCompleted: false, completedDate: nil, illustrationName: "Baby12"),
        ],
        // 5~6개월
        [
            GrowthMilestone(id: "milestone_2_0", title: "혼자 뒤집기", ageRange: "5~6개월", isCompleted: false, completedDate: nil, illustrationName: "Baby13"),
            GrowthMilestone(id: "milestone_2_1", title: "발차기", ageRange: "5~6개월", isCompleted: false, completedDate: nil, illustrationName: "Baby14"),
            GrowthMilestone(id: "milestone_2_2", title: "손 뻗기", ageRange: "5~6개월", isCompleted: false, completedDate: nil, illustrationName: "Baby15"),
            GrowthMilestone(id: "milestone_2_3", title: "물건 잡아 들기", ageRange: "5~6개월", isCompleted: false, completedDate: nil, illustrationName: "Baby16"),
            GrowthMilestone(id: "milestone_2_4", title: "이름 반응하기", ageRange: "5~6개월", isCompleted: false, completedDate: nil, illustrationName: "Baby17"),
            GrowthMilestone(id: "milestone_2_5", title: "낯가림하기", ageRange: "5~6개월", isCompleted: false, completedDate: nil, illustrationName: "Baby18"),
        ],
        // 7~8개월
        [
            GrowthMilestone(id: "milestone_3_0", title: "혼자 앉기", ageRange: "7~8개월", isCompleted: false, completedDate: nil, illustrationName: "Baby19"),
            GrowthMilestone(id: "milestone_3_1", title: "손 번갈아 사용하기", ageRange: "7~8개월", isCompleted: false, completedDate: nil, illustrationName: "Baby20"),
            GrowthMilestone(id: "milestone_3_2", title: "숨긴 물건 찾기", ageRange: "7~8개월", isCompleted: false, completedDate: nil, illustrationName: "Baby21"),
            GrowthMilestone(id: "milestone_3_3", title: " 자음 옹알이하기", ageRange: "7~8개월", isCompleted: false, completedDate: nil, illustrationName: "Baby22"),
            GrowthMilestone(id: "milestone_3_4", title: "손가락으로 과자 집기", ageRange: "7~8개월", isCompleted: false, completedDate: nil, illustrationName: "Baby23"),
            GrowthMilestone(id: "milestone_3_5", title: "부모 애착하기", ageRange: "7~8개월", isCompleted: false, completedDate: nil, illustrationName: "Baby24"),
        ],
        // 9~10개월
        [
            GrowthMilestone(id: "milestone_4_0", title: "배밀기", ageRange: "9~10개월", isCompleted: false, completedDate: nil, illustrationName: "Baby25"),
            GrowthMilestone(id: "milestone_4_1", title: "네발 기기", ageRange: "9~10개월", isCompleted: false, completedDate: nil, illustrationName: "Baby26"),
            GrowthMilestone(id: "milestone_4_2", title: "잡고 서기", ageRange: "9~10개월", isCompleted: false, completedDate: nil, illustrationName: "Baby27"),
            GrowthMilestone(id: "milestone_4_3", title: "작은 물건 잡기", ageRange: "9~10개월", isCompleted: false, completedDate: nil, illustrationName: "Baby28"),
            GrowthMilestone(id: "milestone_4_4", title: "행동 의사 표현하기", ageRange: "9~10개월", isCompleted: false, completedDate: nil, illustrationName: "Baby29"),
            GrowthMilestone(id: "milestone_4_5", title: "손가락으로 음식 먹기", ageRange: "9~10개월", isCompleted: false, completedDate: nil, illustrationName: "Baby30"),
        ],
        // 11~12개월
        [
            GrowthMilestone(id: "milestone_5_0", title: "걷기 시도하기", ageRange: "11~12개월", isCompleted: false, completedDate: nil, illustrationName: "Baby31"),
            GrowthMilestone(id: "milestone_5_1", title: "잡고 계단 오르기 시도", ageRange: "11~12개월", isCompleted: false, completedDate: nil, illustrationName: "Baby32"),
            GrowthMilestone(id: "milestone_5_2", title: "첫 단어 말하기", ageRange: "11~12개월", isCompleted: false, completedDate: nil, illustrationName: "Baby33"),
            GrowthMilestone(id: "milestone_5_3", title: "간단 지시 이해하기", ageRange: "11~12개월", isCompleted: false, completedDate: nil, illustrationName: "Baby34"),
            GrowthMilestone(id: "milestone_5_4", title: "스스로 컵 들고 마시기", ageRange: "11~12개월", isCompleted: false, completedDate: nil, illustrationName: "Baby35"),
            GrowthMilestone(id: "milestone_5_5", title: "부모 반응 살피기", ageRange: "11~12개월", isCompleted: false, completedDate: nil, illustrationName: "Baby36"),
        ],
        // 13~14개월
        [
            GrowthMilestone(id: "milestone_6_0", title: "혼자 걷기", ageRange: "13~14개월", isCompleted: false, completedDate: nil, illustrationName: "Baby37"),
            GrowthMilestone(id: "milestone_6_1", title: "물건 밀기", ageRange: "13~14개월", isCompleted: false, completedDate: nil, illustrationName: "Baby38"),
            GrowthMilestone(id: "milestone_6_2", title: "물건 끌기", ageRange: "13~14개월", isCompleted: false, completedDate: nil, illustrationName: "Baby39"),
            GrowthMilestone(id: "milestone_6_3", title: "흉내내기", ageRange: "13~14개월", isCompleted: false, completedDate: nil, illustrationName: "Baby40"),
            GrowthMilestone(id: "milestone_6_4", title: "숟가락 잡기", ageRange: "13~14개월", isCompleted: false, completedDate: nil, illustrationName: "Baby41"),
            GrowthMilestone(id: "milestone_6_5", title: "호기심", ageRange: "13~14개월", isCompleted: false, completedDate: nil, illustrationName: "Baby42"),
        ],
        // 15~16개월
        [
            GrowthMilestone(id: "milestone_7_0", title: "능숙하게 걷기", ageRange: "15~16개월", isCompleted: false, completedDate: nil, illustrationName: "Baby43"),
            GrowthMilestone(id: "milestone_7_1", title: "오르내리기", ageRange: "15~16개월", isCompleted: false, completedDate: nil, illustrationName: "Baby44"),
            GrowthMilestone(id: "milestone_7_2", title: "공_차기", ageRange: "15~16개월", isCompleted: false, completedDate: nil, illustrationName: "Baby45"),
            GrowthMilestone(id: "milestone_7_3", title: "고집_피우기", ageRange: "15~16개월", isCompleted: false, completedDate: nil, illustrationName: "Baby46"),
            GrowthMilestone(id: "milestone_7_4", title: "정리하기", ageRange: "15~16개월", isCompleted: false, completedDate: nil, illustrationName: "Baby47"),
            GrowthMilestone(id: "milestone_7_5", title: "치우기", ageRange: "15~16개월", isCompleted: false, completedDate: nil, illustrationName: "Baby48"),
        ],
        // 17~18개월
        [
            GrowthMilestone(id: "milestone_8_0", title: "살짝 뛰기", ageRange: "17~18개월", isCompleted: false, completedDate: nil, illustrationName: "Baby49"),
            GrowthMilestone(id: "milestone_8_1", title: "블록 쌓기", ageRange: "17~18개월", isCompleted: false, completedDate: nil, illustrationName: "Baby50"),
            GrowthMilestone(id: "milestone_8_2", title: "단어 조합하기", ageRange: "17~18개월", isCompleted: false, completedDate: nil, illustrationName: "Baby51"),
            GrowthMilestone(id: "milestone_8_3", title: "관심 갖기", ageRange: "17~18개월", isCompleted: false, completedDate: nil, illustrationName: "Baby52"),
            GrowthMilestone(id: "milestone_8_4", title: "혼자 손 씻기", ageRange: "17~18개월", isCompleted: false, completedDate: nil, illustrationName: "Baby53"),
            GrowthMilestone(id: "milestone_8_5", title: "혼자 옷 벗기", ageRange: "17~18개월", isCompleted: false, completedDate: nil, illustrationName: "Baby54"),
        ],
        // 19~20개월
        [
            GrowthMilestone(id: "milestone_9_0", title: "달리기 시도", ageRange: "19~20개월", isCompleted: false, completedDate: nil, illustrationName: "Baby55"),
            GrowthMilestone(id: "milestone_9_1", title: "공 던지기", ageRange: "19~20개월", isCompleted: false, completedDate: nil, illustrationName: "Baby56"),
            GrowthMilestone(id: "milestone_9_2", title: "선/점 그리기", ageRange: "19~20개월", isCompleted: false, completedDate: nil, illustrationName: "Baby57"),
            GrowthMilestone(id: "milestone_9_3", title: "질문하기", ageRange: "19~20개월", isCompleted: false, completedDate: nil, illustrationName: "Baby58"),
            GrowthMilestone(id: "milestone_9_4", title: "역할놀이", ageRange: "19~20개월", isCompleted: false, completedDate: nil, illustrationName: "Baby59"),
            GrowthMilestone(id: "milestone_9_5", title: "숟가락 사용하기", ageRange: "19~20개월", isCompleted: false, completedDate: nil, illustrationName: "Baby60"),
        ],
        // 21~22개월
        [
            GrowthMilestone(id: "milestone_10_0", title: "계단 오르기", ageRange: "21~22개월", isCompleted: false, completedDate: nil, illustrationName: "Baby61"),
            GrowthMilestone(id: "milestone_10_1", title: "공 위로 던지기", ageRange: "21~22개월", isCompleted: false, completedDate: nil, illustrationName: "Baby62"),
            GrowthMilestone(id: "milestone_10_2", title: "순서 따라하기", ageRange: "21~22개월", isCompleted: false, completedDate: nil, illustrationName: "Baby63"),
            GrowthMilestone(id: "milestone_10_3", title: "싫어 주장하기", ageRange: "21~22개월", isCompleted: false, completedDate: nil, illustrationName: "Baby64"),
            GrowthMilestone(id: "milestone_10_4", title: "좋아 주장하기", ageRange: "21~22개월", isCompleted: false, completedDate: nil, illustrationName: "Baby65"),
            GrowthMilestone(id: "milestone_10_5", title: "배변 신호 인식", ageRange: "21~22개월", isCompleted: false, completedDate: nil, illustrationName: "Baby66"),
        ],
        // 23~24개월
        [
            GrowthMilestone(id: "milestone_11_0", title: "안정적 달리기", ageRange: "23~24개월", isCompleted: false, completedDate: nil, illustrationName: "Baby67"),
            GrowthMilestone(id: "milestone_11_1", title: "점프 시도하기", ageRange: "23~24개월", isCompleted: false, completedDate: nil, illustrationName: "Baby68"),
            GrowthMilestone(id: "milestone_11_2", title: "대명사 사용하기", ageRange: "23~24개월", isCompleted: false, completedDate: nil, illustrationName: "Baby69"),
            GrowthMilestone(id: "milestone_11_3", title: "원 그리기", ageRange: "23~24개월", isCompleted: false, completedDate: nil, illustrationName: "Baby70"),
            GrowthMilestone(id: "milestone_11_4", title: "간식 혼자 먹기", ageRange: "23~24개월", isCompleted: false, completedDate: nil, illustrationName: "Baby71"),
            GrowthMilestone(id: "milestone_11_5", title: "도구 혼자 사용하기", ageRange: "23~24개월", isCompleted: false, completedDate: nil, illustrationName: "Baby72"),
        ],
    ]
    
    
    // 서버에서 불러온 이빨 정보
    var teethList: [TeethData] = TeethData.mockData
    
    // MARK: - Stored Properties
    var selectedMilestone: GrowthMilestone {
        allMilestones[selectedMilestoneAgeRangeIdx][selectedMilestoneIdxInAgeRange]
    }
    
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        
        SelectedBabyState.shared.$baby
            .sink { [weak self] baby in
                guard let self = self, let baby = baby else { return }
                print("Selected baby changed to: \(baby.name) (ID: \(baby.babyId)). Fetching new growth data...")
                Task {
                    await self.fetchAllGrowthData(babyId: baby.babyId)
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchAllGrowthData(babyId: Int) async {
        await fetchSelectedBabySummary(babyId: babyId)
        await fetchAllMilestones(babyId: babyId)
        await fetchGrowthData(babyId: babyId)
    }
    
    func fetchAllMilestones(babyId: Int) async {
        let result = await BabyMoaService.shared.getGetBabyMilestones(babyId: babyId)
        switch result {
        case .success(let success):
            guard let milestonesData = success.data else { return }
            for milestone in milestonesData {
                let row = Int(milestone.milestoneName.split(separator: "_")[1])!
                let col = Int(milestone.milestoneName.split(separator: "_")[2])!
                
                var decodedImage: UIImage?
                if let imageUrl = milestone.imageUrl {
                    decodedImage = await ImageManager.shared.downloadImage(from: imageUrl)
                }
                
                allMilestones[row][col].image = decodedImage
                allMilestones[row][col].completedDate = DateFormatter.yyyyDashMMDashdd.date(from: milestone.date)
                allMilestones[row][col].description = milestone.memo
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func setMilestone(milestone: GrowthMilestone) async -> Bool {
        guard let babyId = SelectedBabyState.shared.baby?.babyId else {
            print("Error: No baby selected for setting milestone.")
            return false
        }
        var base64EncodedImage: String?
        if let image = milestone.image {
            base64EncodedImage = ImageManager.shared.encodeToBase64(image)
        }
        let result = await BabyMoaService.shared.postSetBabyMilestone(babyId: babyId, milestoneName: milestone.id, milestoneImage: base64EncodedImage ?? "", date: DateFormatter.yyyyDashMMDashdd.string(from: milestone.completedDate ?? Date()), memo: milestone.description)
        switch result {
        case .success:
            return true
        case .failure(let error):
            print(error)
            return false
        }
    }
    
    func fetchGrowthData(babyId: Int) async {
        let result = await BabyMoaService.shared.getGetGrowthData(babyId: babyId)
        
        print("----------- Growth Data API Response -----------")
        print("Fetching for babyId: \(babyId)")
        print(result)
        print("---------------------------------------------")
        
        switch result {
        case .success(let success):
            guard let data = success.data else {
                print("Growth data is nil.")
                return
            }
            await MainActor.run {
                print("Updating UI with latestHeight: \(data.latestHeight ?? -1), latestWeight: \(data.latestWeight ?? -1)")
                latestHeight = data.latestHeight
                latestWeight = data.latestWeight
                teethList = data.toothStatus
            }
        case .failure(let failure):
            print("Failed to fetch growth data: \(failure)")
        }
    }
    
    func fetchSelectedBabySummary(babyId: Int) async {
        let result = await BabyMoaService.shared.getBaby(babyId: babyId)
        switch result {
        case .success(let success):
            guard let babySummary = success.data else { return }
            let profileImage = await ImageManager.shared.downloadImage(from: babySummary.avatarImageName)
            self.selectedBaby = BabySummary(babyId: babyId, babyName: babySummary.name, babyProfileImage: profileImage)
            
        case .failure(let failure):
            print(failure)
        }
    }
    
    func deleteBabyMilestone() async {
        guard let babyId = SelectedBabyState.shared.baby?.babyId else {
            print("Error: No baby selected for deleting milestone.")
            return
        }
        let result = await BabyMoaService.shared.deleteBabyMilestone(babyId: babyId, milestoneName: selectedMilestone.id)
        switch result {
        case .success:
            isMilestoneEditingViewPresented = false
            initiateSelectedMilestone()
        case .failure(let error):
            print(error)
        }
    }
    
    func initiateSelectedMilestone() {
        allMilestones[selectedMilestoneAgeRangeIdx][selectedMilestoneIdxInAgeRange].image = nil
        allMilestones[selectedMilestoneAgeRangeIdx][selectedMilestoneIdxInAgeRange].completedDate = nil
        allMilestones[selectedMilestoneAgeRangeIdx][selectedMilestoneIdxInAgeRange].description = nil
        allMilestones[selectedMilestoneAgeRangeIdx][selectedMilestoneIdxInAgeRange].isCompleted = false
    }
    
    func beforeMilestoneButtonTapped() {
        if selectedMonthIdx <= 0 {
            return
        }
        selectedMonthIdx -= 1
    }
    
    func afterMilestoneButtonTapped() {
        if selectedMonthIdx >= allMilestones.count - 1 {
            return
        }
        selectedMonthIdx += 1
    }
    
    @MainActor
    func checkAllMilestonesButtonTapped() {
        coordinator.push(path: .allMilestones(allMilestones))
    }
    
    @MainActor
    func navigateToHeightDetail() {
        guard let babyId = SelectedBabyState.shared.baby?.babyId else {
            print("Error: No baby selected.")
            return
        }
        coordinator.push(path: .newHeight(babyId: babyId))
    }
    
    @MainActor
    func navigateToWeightDetail() {
        guard let babyId = SelectedBabyState.shared.baby?.babyId else {
            print("Error: No baby selected.")
            return
        }
        coordinator.push(path: .newWeight(babyId: babyId))
    }
    
    @MainActor
    func toothButtonTapped() {
        coordinator.push(path: .teeth(teethList: teethList))
    }
}
