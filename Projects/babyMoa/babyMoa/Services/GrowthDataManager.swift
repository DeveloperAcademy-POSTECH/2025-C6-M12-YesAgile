//
//  GrowthDataManager.swift
//  babyMoa
//
//  Created by Pherd on 10/28/25.
//
//  성장 데이터 UserDefaults 저장 관리자
//

import Foundation
import SwiftUI

/// 성장 데이터를 UserDefaults에 저장/로드하는 매니저
@Observable
class GrowthDataManager {
    static let shared = GrowthDataManager()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Keys
    
    private enum Keys {
        static let milestones = "growth_milestones_"
        static let milestoneImages = "growth_milestone_images_"
        static let heightRecords = "growth_height_records_"
        static let weightRecords = "growth_weight_records_"
        static let teethRecords = "growth_teeth_records_"
    }
    
    private init() {}
    
    // MARK: - 마일스톤 저장/로드
    
    /// 마일스톤 목록 저장
    func saveMilestones(_ milestones: [GrowthMilestone], for babyId: String) {
        let key = Keys.milestones + babyId
        if let encoded = try? JSONEncoder().encode(milestones) {
            defaults.set(encoded, forKey: key)
            print("✅ 마일스톤 저장 완료: \(milestones.count)개")
        }
    }
    
    /// 마일스톤 목록 로드
    func loadMilestones(for babyId: String) -> [GrowthMilestone] {
        let key = Keys.milestones + babyId
        guard let data = defaults.data(forKey: key),
              let milestones = try? JSONDecoder().decode([GrowthMilestone].self, from: data) else {
            print("⚠️ 마일스톤 로드 실패, 빈 배열 반환")
            return []
        }
        print("✅ 마일스톤 로드 완료: \(milestones.count)개")
        return milestones
    }
    
    /// 마일스톤 이미지 저장 (Base64)
    func saveMilestoneImage(_ image: UIImage, for milestoneId: String, babyId: String) {
        let key = Keys.milestoneImages + babyId + "_" + milestoneId
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            let base64String = jpegData.base64EncodedString()
            defaults.set(base64String, forKey: key)
            print("✅ 마일스톤 이미지 저장 완료: \(milestoneId)")
        }
    }
    
    /// 마일스톤 이미지 로드
    func loadMilestoneImage(for milestoneId: String, babyId: String) -> UIImage? {
        let key = Keys.milestoneImages + babyId + "_" + milestoneId
        guard let base64String = defaults.string(forKey: key),
              let data = Data(base64Encoded: base64String) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    /// 마일스톤 이미지 삭제
    func deleteMilestoneImage(for milestoneId: String, babyId: String) {
        let key = Keys.milestoneImages + babyId + "_" + milestoneId
        defaults.removeObject(forKey: key)
        print("🗑️ 마일스톤 이미지 삭제 완료: \(milestoneId)")
    }
    
    // MARK: - 키 기록 저장/로드
    
    /// 키 기록 목록 저장
    func saveHeightRecords(_ records: [HeightRecord], for babyId: String) {
        let key = Keys.heightRecords + babyId
        if let encoded = try? JSONEncoder().encode(records) {
            defaults.set(encoded, forKey: key)
            print("✅ 키 기록 저장 완료: \(records.count)개")
        }
    }
    
    /// 키 기록 목록 로드
    func loadHeightRecords(for babyId: String) -> [HeightRecord] {
        let key = Keys.heightRecords + babyId
        guard let data = defaults.data(forKey: key),
              let records = try? JSONDecoder().decode([HeightRecord].self, from: data) else {
            print("⚠️ 키 기록 로드 실패, 빈 배열 반환")
            return []
        }
        print("✅ 키 기록 로드 완료: \(records.count)개")
        return records
    }
    
    // MARK: - 몸무게 기록 저장/로드
    
    /// 몸무게 기록 목록 저장
    func saveWeightRecords(_ records: [WeightRecord], for babyId: String) {
        let key = Keys.weightRecords + babyId
        if let encoded = try? JSONEncoder().encode(records) {
            defaults.set(encoded, forKey: key)
            print("✅ 몸무게 기록 저장 완료: \(records.count)개")
        }
    }
    
    /// 몸무게 기록 목록 로드
    func loadWeightRecords(for babyId: String) -> [WeightRecord] {
        let key = Keys.weightRecords + babyId
        guard let data = defaults.data(forKey: key),
              let records = try? JSONDecoder().decode([WeightRecord].self, from: data) else {
            print("⚠️ 몸무게 기록 로드 실패, 빈 배열 반환")
            return []
        }
        print("✅ 몸무게 기록 로드 완료: \(records.count)개")
        return records
    }
    
    // MARK: - 치아 기록 저장/로드
    
    /// 치아 기록 목록 저장
    func saveTeethRecords(_ records: [TeethRecord], for babyId: String) {
        let key = Keys.teethRecords + babyId
        if let encoded = try? JSONEncoder().encode(records) {
            defaults.set(encoded, forKey: key)
            print("✅ 치아 기록 저장 완료: \(records.count)개")
        }
    }
    
    /// 치아 기록 목록 로드
    func loadTeethRecords(for babyId: String) -> [TeethRecord] {
        let key = Keys.teethRecords + babyId
        guard let data = defaults.data(forKey: key),
              let records = try? JSONDecoder().decode([TeethRecord].self, from: data) else {
            print("⚠️ 치아 기록 로드 실패, 빈 배열 반환")
            return []
        }
        print("✅ 치아 기록 로드 완료: \(records.count)개")
        return records
    }
    
    // MARK: - 전체 데이터 삭제 (로그아웃 시 사용)
    
    /// 특정 아기의 모든 성장 데이터 삭제
    func deleteAllData(for babyId: String) {
        defaults.removeObject(forKey: Keys.milestones + babyId)
        defaults.removeObject(forKey: Keys.heightRecords + babyId)
        defaults.removeObject(forKey: Keys.weightRecords + babyId)
        defaults.removeObject(forKey: Keys.teethRecords + babyId)
        
        // 마일스톤 이미지들도 삭제 (패턴 매칭)
        let imageKeyPrefix = Keys.milestoneImages + babyId
        let allKeys = defaults.dictionaryRepresentation().keys
        for key in allKeys where key.hasPrefix(imageKeyPrefix) {
            defaults.removeObject(forKey: key)
        }
        
        print("🗑️ 모든 성장 데이터 삭제 완료: \(babyId)")
    }
}

