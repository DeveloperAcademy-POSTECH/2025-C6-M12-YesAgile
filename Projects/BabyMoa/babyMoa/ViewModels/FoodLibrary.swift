//
//  RecommedFoodViewModel.swift
//  babyMoa
//
//  Created by Baba on 10/29/25.
//

import Foundation

class FoodLibrary: ObservableObject {
    @Published var foodItems: [FoodLibraryItem] = []
    
    init(){
        loadFoodLibrary()
    }
    
    // Food 속성 정의
    
    private func loadFoodLibrary(){
        
        let sixToEightMonths = [
             FoodLibraryItem(name: "쌀 시리얼", category: .grains, recommendedAge: "6-8개월", description: "모유나 분유에 타는 철분 강화 쌀 시리얼", nutritionalInfo: "철분, 비타민 B"),
             FoodLibraryItem(name: "사과 퓌레", category: .fruits, recommendedAge: "6-8개월", description: "부드러운 사과 퓌레, 첫 과일로 좋아요", nutritionalInfo: "비타민 C, 섬유질"),
             FoodLibraryItem(name: "바나나 퓌레", category: .fruits, recommendedAge: "6-8개월", description: "자연적으로 달고 소화하기 쉬워요", nutritionalInfo: "칼륨, 비타민 B6"),
             FoodLibraryItem(name: "당근 퓌레", category: .vegetables, recommendedAge: "6-8개월", description: "달콤하고 영양가 있는 첫 채소", nutritionalInfo: "비타민 A, 베타카로틴"),
             FoodLibraryItem(name: "고구마 퓌레", category: .vegetables, recommendedAge: "6-8개월", description: "자연적으로 달고 영양이 풍부해요", nutritionalInfo: "비타민 A, 섬유질"),
             FoodLibraryItem(name: "아보카도 퓌레", category: .fruits, recommendedAge: "6-8개월", description: "건강한 지방과 크리미한 질감", nutritionalInfo: "저지방, 비타민 E")
         ]
         
         // 8-10 개월 음식
         let eightToTenMonths = [
             FoodLibraryItem(name: "닭고기 퓌레", category: .proteins, recommendedAge: "8-10개월", description: "성장기 아기를 위한 저지방 단백질 공급원", nutritionalInfo: "단백질, 철분, 아연"),
             FoodLibraryItem(name: "연어 퓌레", category: .proteins, recommendedAge: "8-10개월", description: "두뇌 발달을 위한 오메가-3 지방산", nutritionalInfo: "오메가-3, 단백질, 비타민 D"),
             FoodLibraryItem(name: "계란 노른자", category: .proteins, recommendedAge: "8-10개월", description: "콜린과 건강한 지방 풍부", nutritionalInfo: "콜린, 비타민 D, 건강한 지방"),
             FoodLibraryItem(name: "완두콩 퓌레", category: .vegetables, recommendedAge: "8-10개월", description: "좋은 단백질과 섬유질 공급원", nutritionalInfo: "단백질, 섬유질, 비타민 C"),
             FoodLibraryItem(name: "배 퓌레", category: .fruits, recommendedAge: "8-10개월", description: "위에 부담이 없고 자연적으로 달콤해요", nutritionalInfo: "섬유질, 비타민 C"),
             FoodLibraryItem(name: "오트밀", category: .grains, recommendedAge: "8-10개월", description: "에너지를 위한 통곡물의 장점", nutritionalInfo: "섬유질, 철분, 비타민 B")
         ]
         
         // 10-12 개월 음식
         let tenToTwelveMonths = [
             FoodLibraryItem(name: "부드럽게 익힌 채소", category: .vegetables, recommendedAge: "10-12개월", description: "작은 조각의 부드럽게 익힌 채소", nutritionalInfo: "다양한 비타민과 미네랄"),
             FoodLibraryItem(name: "핑거 푸드", category: .other, recommendedAge: "10-12개월", description: "스스로 먹을 수 있는 작고 부드러운 조각", nutritionalInfo: "소근육 발달"),
             FoodLibraryItem(name: "요거트", category: .dairy, recommendedAge: "10-12개월", description: "활성 배양균이 있는 플레인 요거트", nutritionalInfo: "칼슘, 단백질, 프로바이오틱스"),
             FoodLibraryItem(name: "치즈", category: .dairy, recommendedAge: "10-12개월", description: "작은 조각의 부드러운 치즈", nutritionalInfo: "칼슘, 단백질"),
             FoodLibraryItem(name: "통밀빵", category: .grains, recommendedAge: "10-12개월", description: "작은 조각의 부드러운 통밀빵", nutritionalInfo: "섬유질, 비타민 B"),
             FoodLibraryItem(name: "부드러운 과일", category: .fruits, recommendedAge: "10-12개월", description: "작은 조각의 부드러운 과일", nutritionalInfo: "다양한 비타민과 항산화제")
         ]
        
        foodItems = sixToEightMonths + eightToTenMonths + tenToTwelveMonths
        
    }
    
    func getFoodsForAge(_ ageRange: String) -> [FoodLibraryItem] {
        return foodItems.filter { $0.recommendedAge == ageRange }
    }
    
    func getFoodsByCategory(_ category: FoodCategory) -> [FoodLibraryItem] {
        return foodItems.filter { $0.category == category }
    }
    
    func searchFoods(_ query: String) -> [FoodLibraryItem] {
        let lowercasedQuery = query.lowercased()
        return foodItems.filter {
            $0.name.lowercased().contains(lowercasedQuery) ||
            $0.description.lowercased().contains(lowercasedQuery)
        }
    }
    
    
}
