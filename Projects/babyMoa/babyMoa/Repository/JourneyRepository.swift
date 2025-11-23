//
//  JourneyRepository.swift
//  babyMoa
//
//  Created by pherd on 11/21/25.
//

import SwiftUI

actor JourneyRepository {
    static let shared = JourneyRepository()
    
    // 메모리 캐시: ["babyId_year_month": [Journey]]
    // 예: "1_2025_11" -> [Journey]
    private var journeyCache: [String: [Journey]] = [:]
    
    // Actor는 내부적으로 동시성 처리를 보장하므로 NSLock 불필요 ( 에러잡기 위해서 썼었어요 final class X 순차적으로 해야함)
    
    private init() {}
    
    // MARK: - Fetch (with Caching)
    
    /// Journey 목록 가져오기 (캐싱 적용)
    /// - 캐시 키: "babyId_year_month"
    /// - 캐시가 있으면 즉시 반환, 없으면 API 호출 후 저장
    func fetchJourneys(babyId: Int, year: Int, month: Int) async -> [Journey] {
        let cacheKey = "\(babyId)_\(year)_\(month)"
        
        // 1. 캐시 확인 (Actor 내부 변수는 안전하게 접근 가능)
        if let cachedJourneys = journeyCache[cacheKey] {
            return cachedJourneys
        }
        
        // 2. 네트워크 요청
        let result = await BabyMoaService.shared.getGetJourniesAtMonth(babyId: babyId, year: year, month: month)
        
        switch result {
        case .success(let response):
            guard let data = response.data else { 
                return [] 
            }
            
            let newJourneys = data.compactMap { dto -> Journey? in
                
                // Date 변환
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                guard let date = formatter.date(from: dto.date) else { 
                    print("⚠️ [JourneyRepository] Failed to parse date: \(dto.date)")
                    return nil 
                }
                
                let journey = Journey(
                    journeyId: dto.journeyId,
                    journeyImage: nil, // Lazy Loading: ViewModel/View에서 비동기로 로드
                    imageUrl: dto.journeyImageUrl,
                    latitude: dto.latitude,
                    longitude: dto.longitude,
                    date: date,
                    memo: dto.memo
                )
                
                return journey
            }
            
            // 3. 캐시 저장 (Actor 내부라 안전)
            self.journeyCache[cacheKey] = newJourneys
            
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
            // Phase 1: 해당 월의 캐시만 무효화 (다른 월 캐시 유지로 성능 향상)
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            clearCacheForMonth(babyId: babyId, year: year, month: month)
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
            // Phase 1: 해당 월의 캐시만 무효화 (다른 월 캐시 유지로 성능 향상)
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            clearCacheForMonth(babyId: babyId, year: year, month: month)
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
    
    /// 특정 월의 캐시만 삭제 (Phase 1: 성능 최적화)
    /// - 다른 월의 캐시는 유지하여 불필요한 네트워크 요청 방지
    /// - Add/Update 시 해당 월만 새로고침하여 즉각적인 UI 반응
    private func clearCacheForMonth(babyId: Int, year: Int, month: Int) {
        let key = "\(babyId)_\(year)_\(month)"
        journeyCache.removeValue(forKey: key)
    }
    
    /// 특정 아기의 모든 캐시 삭제
    /// - Note: Delete 시에는 전체 캐시 삭제 (journeyId만 받아서 날짜를 모름)
    /// - 또는 로그아웃 등 전체 초기화가 필요한 경우 사용
    func clearCache(for babyId: Int) {
        // 키가 "\(babyId)_"로 시작하는 모든 항목 삭제
        let keysToRemove = journeyCache.keys.filter { $0.hasPrefix("\(babyId)_") }
        for key in keysToRemove {
            journeyCache.removeValue(forKey: key)
        }
    }
    
    /// 전체 캐시 삭제 (로그아웃 등)
    func clearAllCache() {
        journeyCache.removeAll()
    }
}
