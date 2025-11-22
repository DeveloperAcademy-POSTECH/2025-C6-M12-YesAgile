//
//  JourneyRepository.swift
//  babyMoa
//
//  Created by pherd on 11/21/25.
//

import SwiftUI

final class JourneyRepository {
    static let shared = JourneyRepository()
    
    // 메모리 캐시: ["babyId_year_month": [Journey]]
    // 예: "1_2025_11" -> [Journey]
    private var journeyCache: [String: [Journey]] = [:]
    
    private init() {}
    
    // MARK: - Fetch (with Caching)
    
    /// Journey 목록 가져오기 (캐싱 적용)
    /// - 캐시 키: "babyId_year_month"
    /// - 캐시가 있으면 즉시 반환, 없으면 API 호출 후 저장
    func fetchJourneys(babyId: Int, year: Int, month: Int) async -> [Journey] {
        let cacheKey = "\(babyId)_\(year)_\(month)"
        
        // 1. 캐시 확인
        if let cachedJourneys = journeyCache[cacheKey] {
            print("✅ [JourneyRepository] Cache HIT for key: \(cacheKey)")
            return cachedJourneys
        }
        
        print("🟡 [JourneyRepository] Cache MISS. Fetching from server for key: \(cacheKey)")
        
        // 2. 네트워크 요청
        let result = await BabyMoaService.shared.getGetJourniesAtMonth(babyId: babyId, year: year, month: month)
        
        switch result {
        case .success(let response):
            guard let data = response.data else { return [] }
            
            let newJourneys = data.compactMap { dto -> Journey? in
                // Date 변환
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                guard let date = formatter.date(from: dto.date) else { return nil }
                
                return Journey(
                    journeyId: dto.journeyId,
                    journeyImage: UIImage(systemName: "photo")!, // 플레이스홀더 (ViewModel에서 실제 이미지 로드)
                    imageUrl: dto.journeyImageUrl,
                    latitude: dto.latitude,
                    longitude: dto.longitude,
                    date: date,
                    memo: dto.memo
                )
            }
            
            // 3. 캐시 저장
            self.journeyCache[cacheKey] = newJourneys
            print("✅ [JourneyRepository] Fetched & Cached \(newJourneys.count) journeys")
            
            return newJourneys
            
        case .failure(let error):
            print("🔴 [JourneyRepository] Fetch failed: \(error)")
            return []
        }
    }
    
    // MARK: - CRUD Operations (Clear Cache on Success)
    
    /// 여정 추가
    func addJourney(
        babyId: Int,
        image: UIImage,
        latitude: Double,
        longitude: Double,
        date: Date,
        memo: String
    ) async -> Bool {
        
        // 1. 이미지 리사이즈
        let resizedImage = ImageManager.shared.resizeImage(image, maxSize: 1024)
        
        // 2. Base64 인코딩
        guard let base64Image = ImageManager.shared.encodeToBase64(
            resizedImage,
            compressionQuality: 0.7
        ) else {
            print("❌ [JourneyRepository] Image encoding failed")
            return false
        }
        
        // 3. 날짜 포맷
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        // 4. API 호출
        let result = await BabyMoaService.shared.postAddJourney(
            babyId: babyId,
            journeyImage: base64Image,
            latitude: latitude,
            longitude: longitude,
            date: dateString,
            memo: memo
        )
        
        switch result {
        case .success:
            print("✅ [JourneyRepository] Add Success")
            // 캐시 무효화 (데이터 변경됨)
            clearCache(for: babyId)
            return true
        case .failure(let error):
            print("🔴 [JourneyRepository] Add Failed: \(error)")
            return false
        }
    }
    
    /// 여정 수정
    func updateJourney(
        babyId: Int,
        journeyId: Int,
        image: UIImage,
        latitude: Double,
        longitude: Double,
        date: Date,
        memo: String
    ) async -> Bool {
        
        let resizedImage = ImageManager.shared.resizeImage(image, maxSize: 1024)
        guard let base64Image = ImageManager.shared.encodeToBase64(
            resizedImage,
            compressionQuality: 0.7
        ) else { return false }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        let result = await BabyMoaService.shared.patchUpdateJourney(
            babyId: babyId,
            journeyId: journeyId,
            journeyImage: base64Image,
            latitude: latitude,
            longitude: longitude,
            date: dateString,
            memo: memo
        )
        
        switch result {
        case .success:
            clearCache(for: babyId)
            return true
        case .failure(let error):
            print("🔴 [JourneyRepository] Update Failed: \(error)")
            return false
        }
    }
    
    /// 여정 삭제
    func deleteJourney(babyId: Int, journeyId: Int) async -> Bool {
        let result = await BabyMoaService.shared.deleteJourney(babyId: babyId, journeyId: journeyId)
        switch result {
        case .success:
            clearCache(for: babyId)
            return true
        case .failure(let error):
            print("🔴 [JourneyRepository] Delete Failed: \(error)")
            return false
        }
    }
    
    // MARK: - Cache Management
    
    /// 특정 아기의 모든 캐시 삭제
    /// - Note: 데이터 변경(추가/수정/삭제) 시 호출하여 오래된 데이터가 보이는 것을 방지
    func clearCache(for babyId: Int) {
        // 키가 "\(babyId)_"로 시작하는 모든 항목 삭제
        let keysToRemove = journeyCache.keys.filter { $0.hasPrefix("\(babyId)_") }
        for key in keysToRemove {
            journeyCache.removeValue(forKey: key)
        }
        print("ℹ️ [JourneyRepository] Cleared cache for baby \(babyId)")
    }
    
    /// 전체 캐시 삭제 (로그아웃 등)
    func clearAllCache() {
        journeyCache.removeAll()
        print("ℹ️ [JourneyRepository] All cache cleared")
    }
}
