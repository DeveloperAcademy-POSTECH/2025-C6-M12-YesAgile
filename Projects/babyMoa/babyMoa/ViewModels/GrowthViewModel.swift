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

@Observable
final class GrowthViewModel {
    // MARK: - Properties
    
    var selectedBabyId: String = "baby1" // TODO: 실제 아기 ID로 변경해야함
    var selectedMonth: Int = 0
    
    /// 로컬에서 방금 선택/저장한 마일스톤 이미지를 캐시 (업로드/응답 전에도 즉시 반영)
    var milestoneLocalImages: [String: UIImage] = [:]
    
    /// UserDefaults 데이터 매니저
    private let dataManager = GrowthDataManager.shared
    
    // 마일스톤 데이터 더 추가 예정
    var allMilestones: [[GrowthMilestone]] = [
        // 0~2개월
        [
            GrowthMilestone(title: "화내기", ageRange: "0~2개월", isCompleted: true, completedDate: Date()),
            GrowthMilestone(title: "기기", ageRange: "0~2개월", isCompleted: false),
        ],
        // 3~5개월
        [
            GrowthMilestone(title: "뒤집기", ageRange: "3~5개월", isCompleted: false),
            GrowthMilestone(title: "목가누기", ageRange: "3~5개월", isCompleted: false),
        ],
    ]
    
    // 측정 기록
    var heightRecords: [HeightRecord] = []
    var weightRecords: [WeightRecord] = []
    var teethRecords: [TeethRecord] = []
    
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
    
    // MARK: - Initialization
    
    init() {
        loadAllData()
    }
    
    /// UserDefaults에서 모든 데이터 로드
    func loadAllData() {
        // 마일스톤 로드 (저장된 것이 있으면 덮어쓰기)
        let savedMilestones = dataManager.loadMilestones(for: selectedBabyId)
        if !savedMilestones.isEmpty {
            // 저장된 데이터를 2개월 단위로 그룹화
            let grouped = Dictionary(grouping: savedMilestones) { $0.ageRange }
            allMilestones = grouped.sorted { $0.key < $1.key }.map { $0.value }
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
    
    func addHeightRecord(height: Double, date: Date, memo: String?) {
        let record = HeightRecord(
            babyId: selectedBabyId,
            height: height,
            date: date,
            memo: memo
        )
        heightRecords.insert(record, at: 0)
        // UserDefaults 저장
        dataManager.saveHeightRecords(heightRecords, for: selectedBabyId)
    }
    
    func addWeightRecord(weight: Double, date: Date, memo: String?) {
        let record = WeightRecord(
            babyId: selectedBabyId,
            weight: weight,
            date: date,
            memo: memo
        )
        weightRecords.insert(record, at: 0)
        // UserDefaults 저장
        dataManager.saveWeightRecords(weightRecords, for: selectedBabyId)
    }
    
    /// 치아 기록 저장 (TeethView에서 변경 후 호출)
    func saveTeethRecords() {
        dataManager.saveTeethRecords(teethRecords, for: selectedBabyId)
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
        
        // 1. 이미지 업로드 (있는 경우)
        var imageURL: String? = milestone.imageURL
        if let image {
            // UI 즉시 반영을 위한 로컬 캐시 저장
            milestoneLocalImages[milestone.id] = image
        }
        if let image = image {
            do {
                let uploadedData = try await GrowthRepository.shared.uploadMilestoneImage(
                    milestoneId: milestone.id,
                    image: image
                )
                // 서버 응답에서 URL 파싱
                if let response = try? JSONDecoder().decode(ImageUploadResponse.self, from: uploadedData) {
                    imageURL = response.imageURL
                    print("✅ [GrowthViewModel] 이미지 업로드 완료: \(response.imageURL)")
                }
            } catch {
                print("❌ [GrowthViewModel] 이미지 업로드 실패: \(error)")
            }
        }
        
        // 2. 메타데이터 업데이트
        do {
            try await GrowthRepository.shared.updateMilestone(
                milestoneId: milestone.id,
                date: date,
                memo: memo,
                imageURL: imageURL,
                isCompleted: true
            )
            print("✅ [GrowthViewModel] 마일스톤 메타데이터 업데이트 완료")
            
            // 3. 로컬 데이터 갱신
            await MainActor.run {
                updateLocalMilestone(milestone, imageURL: imageURL, memo: memo, date: date)
                
                // 4. UserDefaults에 저장
                if let image = image {
                    dataManager.saveMilestoneImage(image, for: milestone.id, babyId: selectedBabyId)
                }
                // 마일스톤 전체 목록 저장
                let flatMilestones = allMilestones.flatMap { $0 }
                dataManager.saveMilestones(flatMilestones, for: selectedBabyId)
            }
        } catch {
            print("❌ [GrowthViewModel] 마일스톤 업데이트 실패: \(error)")
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
                    description: memo
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


