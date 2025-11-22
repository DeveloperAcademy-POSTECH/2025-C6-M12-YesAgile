/*
 ===================================================================================
 [File Name] : JourneyListView.swift
 [Role]      : 특정 날짜에 해당하는 여정들의 상세 목록을 보여주는 UI
 [Layer]     : View (Presentation Layer)
 ===================================================================================
 
 [핵심 책임 (Core Responsibilities)]
 1. **Rendering**: 부모에게 전달받은 `[JourneyModel]` 리스트를 스크롤 가능한 형태로 보여줍니다.
 2. **Performance**: `CachedAsyncImage`를 사용하여 스크롤 시에도 버벅임 없이 이미지를 로드합니다.
 3. **Interaction**: '삭제'나 '수정' 버튼을 누르면 부모에게 신호를 보냅니다.
 
 [설계 의도 및 이유 (Why)]
 1. 왜 ViewModel이 없는가?
 - 이 뷰는 단순히 데이터를 나열해서 보여주기만 하면 됩니다.
 - 별도의 상태 관리나 복잡한 로직이 필요 없으므로, 데이터만 주입받는 '수동적 뷰'로 설계했습니다.
 
 2. CachedAsyncImage 필수
 - `UIImage`를 직접 쓰지 않고 URL 기반으로 로딩해야 메모리 폭발을 막을 수 있습니다.
 */



// MARK: - 1. Properties
/*
 [journies: [JourneyModel]]
 - 부모(Main)가 필터링해서 넘겨준 '해당 날짜의 여정 리스트'입니다.
 */

/*
 [onEdit: (JourneyModel) -> Void]
 - 수정 버튼 클릭 시 호출할 클로저입니다.
 */

/*
 [onDelete: (JourneyModel) -> Void]
 - 삭제 버튼 클릭 시 호출할 클로저입니다.
 */

// MARK: - 2. Body
/*
 [구현 가이드]
 - ScrollView > LazyVStack 구조를 사용합니다.
 - ForEach(journies)를 돌면서 `JourneyCard`(카드 형태 디자인)를 그립니다.
 - 각 카드 내부 이미지: `CachedAsyncImage(urlString: journey.imageURL)` 사용
 - 각 카드 내부 텍스트: `journey.memo` 표시
 */
