//
//  FoodLibraryItem.swift
//  babyMoa
//
//  Created by Baba on 10/30/25.
//

import Foundation

// 기능이 늘어날 가능성(추천, 연령 필터, API/SwiftData 연동, 다국어 등)**이 있다면: 분리
// 연령별/영양 정보 기반 추천, 검색, 정렬 등 라이브러리 로직이 증가 ?? 될까??

struct FoodLibraryItem: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let category: FoodCategory
    let recommendedAge: String // e.g., "6-8 months"
    let description: String
    let nutritionalInfo: String?
    
    init(id: UUID = UUID(), name: String, category: FoodCategory, recommendedAge: String, description: String, nutritionalInfo: String? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.recommendedAge = recommendedAge
        self.description = description
        self.nutritionalInfo = nutritionalInfo
    }
}
