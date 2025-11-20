//
//  RecommenFood.swift
//  babyMoa
//
//  Created by Baba on 10/29/25.
//


// 이것은 추후에 계속 유지되면서 사용할 것인가? 그렇데 그러면 Struct로 만들자.

import Foundation

// 정의 : Food가 받는 데이터는 변경되지 않아서 구조체로 만는다.
// 고유한 값이 있어야 한다.
// 추후에 이것은 통신에서 가져오던지 DB와 연결될 수 있어서 API통신을 위해 Codable을 따른다.

//아기가 섭취한 한 끼 식사 또는 음식 항목을 저장하기 위한 모델
// Identifiable: SwiftUI에서 리스트(List) 렌더링 시 각 항목을 고유하게 식별할 수 있게 합니다.
// Codable: JSON 직렬화/역직렬화가 가능하여 로컬 저장(UserDefaults, 파일 저장)이나 API 통신에 사용

struct BabyFoodEntry: Identifiable, Codable {
    let id: UUID // 고유 식별자
     var date: Date // 음식 기록의 날짜와 시간
     var foodName: String // 음식 이름 (라이브러리 또는 사용자 정의)
     var foodCategory: FoodCategory // 음식을 카테고리별로 분류하기 위한 항목 (아래 Enum의 값을 활당한다.)
     var amount: Double // 음식의 양 (그램 또는 밀리리터 단위)
     var amountUnit: AmountUnit // 측정 단위
     var isFromLibrary: Bool // 라이브러리에서 선택된 음식인지 여부
     var photoData: Data? // 아기 사진 데이터 (옵션, Data 형식으로 저장)
     var notes: String? // 추가 메모 (선택 사항)

    // init()은 미리보기나 테스트용 초기화 기본값
    init(id: UUID = UUID(),
         date: Date,
         foodName: String,
         foodCategory: FoodCategory = .other,
         amount: Double = 0.0,
         amountUnit: AmountUnit = .ounces,
         isFromLibrary: Bool = false,
         photoData: Data? = nil,
         notes: String? = nil) {
        self.id = id
        self.date = date
        self.foodName = foodName
        self.foodCategory = foodCategory
        self.amount = amount
        self.amountUnit = amountUnit
        self.isFromLibrary = isFromLibrary
        self.photoData = photoData
        self.notes = notes
    }
}

// 음식 분류를 통해 체계적인 관리와 AI 분석을 지원
// 음식을 관리하기 쉽게 만듬, 각 음식에 대한 특징을  String 문자로 정의 함.
// 색 또한 정의 함 (칼라칩이 완성되면 정리하기 쉽게 하기 위해함)
// CaseIterable: 모든 케이스를 순회(forEach 등)하여 사용할 수 있게 하기 위함.왜냐하면, 화면에 출력되는 화면으로 모든 케이스가 나오도록 설정함.
enum FoodCategory: String, CaseIterable, Codable {
    case fruits = "Fruits"
    case vegetables = "Vegetables" // 아기에게 섬유질료 표현하는것이 좋은지 아니면 채소로 표시하는게 좋은지>// 채소로 하자.
    case grains = "Grains"
    case proteins = "Proteins"
    case dairy = "Dairy"
    case other = "Other"
    
     // 시각화하기 위해 사용함
    var icon: String {
        switch self {
        case .fruits: return "🍎"
        case .vegetables: return "🥕"
        case .grains: return "🌾"
        case .proteins: return "🥩"
        case .dairy: return "🥛"
        case .other: return "🍽️"
        }
    }
    
    // 색으로 분관하기 쉽게 하기 위해 사용함.
    var color: String {
        switch self {
        case .fruits: return "red"
        case .vegetables: return "green"
        case .grains: return "yellow"
        case .proteins: return "orange"
        case .dairy: return "blue"
        case .other: return "gray"
        }
    }
}

// 과일에 대한 무게를 받기 위해 데이터를 사용함.이유식 또는 퓨레의 경우 oz, g, 등 다양한 단위를 사용함.
// 단위에 대하 관리하기 쉽게 만들고 그 않에 속성을 추가해서
enum AmountUnit: String, CaseIterable, Codable {
    case ounces = "oz"
    case grams = "g"
    case milliliters = "ml"
    case tablespoons = "tbsp"
    case teaspoons = "tsp"
    case cups = "cups"
    case pieces = "pieces"
    
    var displayName: String {
        switch self {
        case .ounces: return "ounces"
        case .grams: return "grams"
        case .milliliters: return "ml"
        case .tablespoons: return "tablespoons"
        case .teaspoons: return "teaspoons"
        case .cups: return "cups"
        case .pieces: return "pieces"
        }
    }
}
