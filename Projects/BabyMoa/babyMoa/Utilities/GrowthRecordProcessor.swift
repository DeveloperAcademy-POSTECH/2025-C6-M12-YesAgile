import Foundation

/// GrowthRecord 프로토콜을 따르는 데이터 모델을 처리하는 범용 계산기
struct GrowthRecordProcessor {
    
    /// GrowthRecord 배열을 받아 monthLabel과 diffText를 계산하여 반환합니다.
    /// - Parameters:
    ///   - records: GrowthRecord 프로토콜을 따르는 모델의 배열
    ///   - babyBirthday: 아기의 생년월일
    /// - Returns: monthLabel과 diffText가 채워진 모델의 배열
    static func process<T: GrowthRecord>(records: [T], babyBirthday: Date?) -> [T] {
        guard let birthday = babyBirthday else { return records }
        
        // 1. 측정 날짜 기준으로 오름차순 정렬
        var sortedRecords = records.sorted { $0.dateValue < $1.dateValue }
        
        // 2. 각 기록에 대해 monthLabel과 diffText 계산
        for i in 0..<sortedRecords.count {
            // monthLabel 계산
            sortedRecords[i].monthLabel = calculateAge(birthday: birthday, measuredOn: sortedRecords[i].dateValue)
            
            // diffText 계산
            if i > 0 { // 첫 번째 기록이 아닐 경우에만 계산
                let previousValue = sortedRecords[i - 1].value
                let currentValue = sortedRecords[i].value
                let difference = currentValue - previousValue
                
                // 단위(cm, kg)를 사용하여 diffText 포맷팅
                sortedRecords[i].diffText = String(format: "%+.1f%@", difference, sortedRecords[i].unit)
            } else {
                sortedRecords[i].diffText = nil // 첫 번째 기록은 차이값이 없음
            }
        }
        
        // 3. 최신순으로 보여주기 위해 배열을 뒤집어서 반환
        return sortedRecords.reversed()
    }
    
    /// 생후 몇 개월인지 계산하는 private 함수
    private static func calculateAge(birthday: Date, measuredOn: Date) -> String? {
        let components = Calendar.current.dateComponents([.month, .day], from: birthday, to: measuredOn)
        if let month = components.month, let day = components.day {
            return "생후 \(month)개월 \(day)일"
        }
        return nil
    }
}
