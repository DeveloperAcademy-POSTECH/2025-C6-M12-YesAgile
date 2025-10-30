//
//  GrowthViewModel.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  성장 기록 뷰모델
//

import Foundation
import SwiftUI
import UIKit

extension Notification.Name {
    static let babyDataDidChange = Notification.Name("babyDataDidChange")
}

@Observable
final class GrowthViewModel {
    // MARK: - Properties
    
    var selectedBabyId: String = ""
    var selectedMonth: Int = 0
    
    /// 로컬에서 방금 선택/저장한 마일스톤 이미지를 캐시 (업로드/응답 전에도 즉시 반영)
    var milestoneLocalImages: [String: UIImage] = [:]
    
    /// UserDefaults 데이터 매니저
    private let dataManager = GrowthDataManager.shared
    
    // 마일스톤 데이터 더 추가 예정
    var allMilestones: [[GrowthMilestone]] = [
        // 0~2개월
        [
            GrowthMilestone(id: "milestone_0_0", title: "누워있기", ageRange: "0~2개월", isCompleted: false, completedDate: nil, illustrationName: "Baby01"),
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
    
    // 측정 기록
    var heightRecords: [HeightRecord] = [] // MARK: 메인에서는 최근 기록만 보여주도록 해당 데이터는 필요 없음
    var weightRecords: [WeightRecord] = [] // MARK: 메인에서는 최근 기록만 보여주도록 "
    var teethRecords: [TeethRecord] = [] // ok
    
    // MARK: - Computed Properties
    
    var currentMilestones: [GrowthMilestone] {
        guard selectedMonth < allMilestones.count else { return [] }
        return allMilestones[selectedMonth]
    }
    
    var latestHeight: HeightRecord? {
        heightRecords.first
    }
    
    var latestWeight: WeightRecord? {
        weightRecords.first
    }
    
    // ------- 위 ViewModel 데이터 필드 값들은 잘 작성되어 있음. -------
    
    // MARK: - Initialization
    
    private var babyDataChangedObserver: NSObjectProtocol?

    init() {
        // UserDefaults에서 현재 아기 ID 로드
        if let data = UserDefaults.standard.data(forKey: "currentBaby"),
           let baby = try? JSONDecoder().decode(Baby.self, from: data) {
            selectedBabyId = baby.id
            print("✅ [GrowthViewModel] 아기 ID 로드: \(baby.id)")
        } else {
            print("⚠️ [GrowthViewModel] 아기 정보 없음, 기본 ID 사용: \(selectedBabyId)")
        }

        babyDataChangedObserver = NotificationCenter.default.addObserver(
            forName: .babyDataDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            print("🔄 [GrowthViewModel] 아기 데이터 변경 감지 → 리로드")
            if let data = UserDefaults.standard.data(forKey: "currentBaby"),
               let baby = try? JSONDecoder().decode(Baby.self, from: data) {
                selectedBabyId = baby.id
            }
            loadAllData()
        }

        loadAllData()
    }

    deinit {
        if let observer = babyDataChangedObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /// UserDefaults에서 모든 데이터 로드
    func loadAllData() {
        // 마일스톤 로드 (저장된 것이 있으면 덮어쓰기)
        let savedMilestones = dataManager.loadMilestones(for: selectedBabyId)
        if !savedMilestones.isEmpty {
            // 저장된 데이터를 2개월 단위로 그룹화
            let grouped = Dictionary(grouping: savedMilestones) { $0.ageRange }
            allMilestones = grouped.sorted { $0.key < $1.key }.map { $0.value }
        } else {
            // 저장된 마일스톤이 없으면 기본 마일스톤을 UserDefaults에 저장
            let flatMilestones = allMilestones.flatMap { $0 }
            dataManager.saveMilestones(flatMilestones, for: selectedBabyId)
            print("✅ [GrowthViewModel] 초기 마일스톤 저장 완료")
        }
        
        // 마일스톤 이미지 로드
        for monthMilestones in allMilestones {
            for milestone in monthMilestones {
                if let image = dataManager.loadMilestoneImage(for: milestone.id, babyId: selectedBabyId) {
                    milestoneLocalImages[milestone.id] = image
                }
            }
        }
        
        // 키/몸무게/치아 기록 로드
        heightRecords = dataManager.loadHeightRecords(for: selectedBabyId)
        weightRecords = dataManager.loadWeightRecords(for: selectedBabyId)
        teethRecords = dataManager.loadTeethRecords(for: selectedBabyId)
    }
    
    // MARK: - Methods
    
    private func resolveBabyIdAndEnsureData() -> String? {
        if !selectedBabyId.isEmpty {
            return selectedBabyId
        }
        if let data = UserDefaults.standard.data(forKey: "currentBaby"),
           let baby = try? JSONDecoder().decode(Baby.self, from: data) {
            selectedBabyId = baby.id
            print("ℹ️ [GrowthViewModel] 현재 아기 ID 동기화: \(baby.id)")
            loadAllData()
            return selectedBabyId
        }
        print("⚠️ [GrowthViewModel] 아기 ID를 찾을 수 없어 기록을 저장하지 않습니다")
        return nil
    }
    
    func addHeightRecord(height: Double, date: Date, memo: String?) {
        guard let babyId = resolveBabyIdAndEnsureData() else { return }
        let record = HeightRecord(
            babyId: babyId,
            height: height,
            date: date,
            memo: memo
        )
        heightRecords.insert(record, at: 0)
        // UserDefaults 저장
        dataManager.saveHeightRecords(heightRecords, for: babyId)
    }
    
    func addWeightRecord(weight: Double, date: Date, memo: String?) {
        guard let babyId = resolveBabyIdAndEnsureData() else { return }
        let record = WeightRecord(
            babyId: babyId,
            weight: weight,
            date: date,
            memo: memo
        )
        weightRecords.insert(record, at: 0)
        // UserDefaults 저장
        dataManager.saveWeightRecords(weightRecords, for: babyId)
    }
    
    /// 치아 기록 저장 (TeethView에서 변경 후 호출)
    func saveTeethRecords() {
        guard let babyId = resolveBabyIdAndEnsureData() else { return }
        dataManager.saveTeethRecords(teethRecords, for: babyId)
        print("✅ 치아 기록 저장 완료: \(teethRecords.count)개")
    }
    
    /// 마일스톤 업데이트 (사진, 날짜, 메모 저장)
    /// - Parameters:
    ///   - milestone: 업데이트할 마일스톤
    ///   - image: 선택된 이미지 (옵셔널)
    ///   - memo: 메모 (옵셔널)
    ///   - date: 작성일
    func saveMilestone(_ milestone: GrowthMilestone, image: UIImage?, memo: String?, date: Date) async {
        print("💾 [GrowthViewModel] 마일스톤 저장 시작: \(milestone.title)")
        guard !selectedBabyId.isEmpty else {
            print("⚠️ [GrowthViewModel] 선택된 아기 ID가 없어 로컬 저장을 건너뜁니다")
            return
        }
        
        var resultingImageURL: String? = milestone.imageURL
        
        if let image {
            milestoneLocalImages[milestone.id] = image
        }
        
        do {
            if let image {
                let uploadedData = try await GrowthRepository.shared.uploadMilestoneImage(
                    milestoneId: milestone.id,
                    image: image
                )
                if let response = try? JSONDecoder().decode(ImageUploadResponse.self, from: uploadedData) {
                    resultingImageURL = response.imageURL
                    print("✅ [GrowthViewModel] 이미지 업로드 완료: \(response.imageURL)")
                }
            }
            try await GrowthRepository.shared.updateMilestone(
                milestoneId: milestone.id,
                date: date,
                memo: memo,
                imageURL: resultingImageURL,
                isCompleted: true
            )
            print("✅ [GrowthViewModel] 마일스톤 메타데이터 업데이트 완료")
        } catch {
            print("❌ [GrowthViewModel] 서버 업데이트 실패: \(error)")
        }
        
        await MainActor.run {
            updateLocalMilestone(milestone, imageURL: resultingImageURL, memo: memo, date: date)
            if let image {
                dataManager.saveMilestoneImage(image, for: milestone.id, babyId: selectedBabyId)
            }
            let flatMilestones = allMilestones.flatMap { $0 }
            dataManager.saveMilestones(flatMilestones, for: selectedBabyId)
        }
    }
    
    /// 로컬 마일스톤 데이터 갱신 (UI 반영)
    private func updateLocalMilestone(_ milestone: GrowthMilestone, imageURL: String?, memo: String?, date: Date) {
        // allMilestones 배열에서 해당 마일스톤 찾아서 업데이트
        for (sectionIndex, section) in allMilestones.enumerated() {
            if let itemIndex = section.firstIndex(where: { $0.id == milestone.id }) {
                let updated = GrowthMilestone(
                    id: milestone.id,
                    title: milestone.title,
                    ageRange: milestone.ageRange,
                    imageURL: imageURL,
                    isCompleted: true,
                    completedDate: date,
                    description: memo,
                    illustrationName: milestone.illustrationName  // 일러스트 이름 유지
                )
                allMilestones[sectionIndex][itemIndex] = updated
                print("✅ [GrowthViewModel] 로컬 데이터 업데이트 완료")
                return
            }
        }
    }
    
    // MARK: - Data Loading
    
    func loadBabyData(babyId: String) {
        // TODO: 실제 데이터 로드
        self.selectedBabyId = babyId
    }
    
    func refreshData() {
        // TODO: 데이터 새로고침
    }
}


