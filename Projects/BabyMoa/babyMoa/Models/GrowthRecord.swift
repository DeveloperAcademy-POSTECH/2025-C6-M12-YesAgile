import Foundation

/// 성장에 관련된 기록(키, 몸무게 등)이 공통적으로 가져야 할 속성을 정의하는 프로토콜
protocol GrowthRecord {
    /// 계산에 사용될 Date 타입의 날짜
    var dateValue: Date { get }
    
    /// 계산에 사용될 Double 타입의 값 (키, 몸무게 등)
    var value: Double { get }
    
    /// 값의 단위 (예: "cm", "kg")
    var unit: String { get }
    
    /// 계산 결과를 할당할 '생후 N개월' 라벨
    var monthLabel: String? { get set }
    
    /// 계산 결과를 할당할 '이전 기록과의 차이' 텍스트
    var diffText: String? { get set }
}
