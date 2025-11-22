/*
 ===================================================================================
 [File Name] : JourneyCalendarViewModel.swift
 [Role]      : 달력 UI를 그리기 위한 날짜 계산 및 상태 관리 (Pure Logic)
 [Layer]     : ViewModel (Component Level)
 ===================================================================================
 
 [핵심 책임 (Core Responsibilities)]
 1. **Month State**: 현재 사용자가 보고 있는 '월(Month)'을 관리합니다.
 2. **Grid Calculation**: 해당 월을 기준으로 달력 그리드(6주, 42일)에 들어갈 날짜 배열을 계산합니다.
 3. **Navigation**: 이전 달, 다음 달로 이동하는 로직을 수행합니다.
 4. **Helper**: 특정 날짜가 이번 달에 포함되는지, 헤더 텍스트는 무엇인지 등을 제공합니다.
 
 [설계 원칙 (Design Principles)]
 1. **데이터 몰라요**: 이 뷰모델은 `JourneyModel`이나 서버 데이터를 전혀 모릅니다. 오직 `Date`만 다룹니다.
 2. **독립성**: 메인 뷰모델(`JourneyViewModel`)에 의존하지 않고 독립적으로 동작해야 합니다.
 */

// TODO: Import 필요한 프레임워크 (Foundation, SwiftUI)

// TODO: Class 선언 (@Observable, @MainActor)

    // MARK: - 1. State (상태)
    /*
     - currentMonth: Date (현재 보고 있는 월)
     - days: [Date] (달력 그리드에 뿌려질 42개의 날짜 배열)
     */
    
    // MARK: - 2. Initializer
    /*
     - init(): 초기화 시점의 날짜를 기준으로 `generateDaysInMonth()`를 호출하여 `days`를 채웁니다.
     */
    
    // MARK: - 3. Actions (기능)
    
    /*
     [changeMonth(by value: Int)]
     - 파라미터로 받은 값(-1 또는 +1)만큼 `currentMonth`를 변경합니다.
     - 변경 후 반드시 `generateDaysInMonth()`를 다시 호출하여 그리드를 갱신합니다.
     */
    
    /*
     [generateDaysInMonth()] - private
     - `currentMonth`를 기준으로 해당 월의 시작일과 끝일, 그리고 달력의 첫 주 시작일(일요일)을 계산합니다.
     - 첫 주 일요일부터 하루씩 더해가며 총 42일(6주)치의 날짜 배열(`days`)을 만듭니다.
     */
    
    // MARK: - 4. Helpers (UI 지원)
    
    /*
     [isDateInCurrentMonth(_ date: Date) -> Bool]
     - 입력받은 날짜가 현재 보고 있는 월(`currentMonth`)에 속하는지 판단합니다.
     - 뷰에서 '이번 달이 아닌 날짜'를 흐리게 표시할 때 사용합니다.
     */
    
    /*
     [monthYearString: String]
     - 상단 헤더에 표시할 "yyyy년 M월" 형태의 문자열을 반환합니다.
     
     🗓️ 1. JourneyCalendarViewModel: "달력 인쇄소"
     이 뷰모델은 **데이터(사진)**에는 전혀 관심이 없습니다. 오직 시간과 날짜라는 수학적인 계산만 담당합니다.

     비유: [달력 공장장]
     이 공장장은 사진을 붙이는 일은 하지 않습니다. 오직 **"빈 달력 종이(Grid)"**를 정확하게 찍어내는 일만 합니다.

     "이번 달 1일은 무슨 요일이지?", "이번 달은 30일까지인가 31일까지인가?", "지난달 마지막 며칠을 달력 앞부분에 채워야 하나?" 같은 복잡한 계산을 도맡아 합니다.

     왜 이렇게 분리했나요? (Why)
     복잡성 격리: 날짜 계산 로직(윤년, 요일 등)은 생각보다 복잡합니다. 이 로직이 메인 데이터 로직과 섞이면 코드가 매우 지저분해집니다.

     안전성: 서버에서 사진 데이터를 못 받아와도, 달력의 날짜 틀은 깨지지 않고 정상적으로 그려져야 합니다. 데이터를 몰라야 안전합니다.

     하는 일 (Responsibility)
     달력판 생성: "이번 달은 11월이니까, 10월 27일(일)부터 12월 7일(토)까지 총 42칸을 만드세요"라고 뷰에게 알려줍니다.

     페이지 넘김: 사용자가 화살표를 누르면 "자, 이제 12월 달력판을 새로 찍어냅니다"라고 계산을 다시 수행합니다.
     
     */
