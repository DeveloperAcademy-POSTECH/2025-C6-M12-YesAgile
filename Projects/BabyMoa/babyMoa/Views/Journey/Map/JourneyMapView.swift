/*
 ===================================================================================
 [File Name] : JourneyMapView.swift
 [Role]      : 전체 화면 지도 UI 및 마커 배치 담당
 [Layer]     : View (Main Component)
 ===================================================================================
 
 [핵심 책임 (Core Responsibilities)]
 1. **Map Rendering**: `MapKit`을 사용하여 지도를 화면에 그립니다.
 2. **Annotation Placement**: 부모(Main)에게 받은 전체 여정 리스트(`allJournies`)를 순회하며 지도에 핀을 꽂습니다.
 3. **User Location**: `JourneyMapViewModel`과 협력하여 '나침반 버튼'을 누르면 현재 위치로 이동합니다.
 4. **Signal Sending**: 핀을 누르면 부모(Main)에게 "이 여정이 선택됐어!"라고 신호를 보냅니다.
 
 [설계 의도 및 이유 (Why)]
 1. 데이터와 상태의 분리
    - 데이터(`journies`): 부모 뷰모델(`JourneyViewModel`)이 관리하는 '보여줄 내용'입니다.
    - 상태(`cameraPosition`): 내 뷰모델(`JourneyMapViewModel`)이 관리하는 '보여줄 위치'입니다.
    - 이 둘을 분리함으로써, 데이터가 바뀌어도 카메라 위치가 튀거나, 지도를 움직여도 데이터가 사라지지 않습니다.
 
 2. 비유 (Metaphor): "전시회장"
    - 이 뷰는 거대한 '전시회장(Map)'입니다.
    - 부모 뷰모델은 '전시품(데이터)'을 트럭으로 실어다 줍니다.
    - 내 뷰모델(MapVM)은 '조명 감독'이라서 관람객이 어디를 볼지(Camera) 조절합니다.
 */

    
    // MARK: - 1. Internal Properties (UI Logic)
    /*
     [viewModel]
     - `@State`로 선언하여 `JourneyMapViewModel`을 소유합니다.
     - 지도의 카메라 이동, 줌, 현재 위치 찾기 로직을 담당합니다.
     */
    
    // MARK: - 2. External Properties (Data Injection)
    /*
     [journies: [JourneyModel]]
     - 부모(Main)에게서 전달받은 '모든' 여정 데이터입니다.
     - 필터링 없이 전부 지도에 표시합니다.
     */
    
    /*
     [onPinSelected: (JourneyModel) -> Void]
     - 사용자가 핀을 탭했을 때 호출할 클로저입니다.
     - 부모(Main)에게 선택된 여정 정보를 전달합니다.
     */
    
    // MARK: - 3. Body
    /*
     [ZStack 구조]
     1. Map(position: $viewModel.cameraPosition)
        - `ForEach(journies)`를 사용하여 `Annotation`을 생성합니다.
        - 각 Annotation의 내용은 `JourneyMapMarkerView`를 사용합니다.
        - `.onTapGesture`에서 `onPinSelected(journey)`를 호출합니다.
        - `UserAnnotation()`을 추가하여 내 위치 파란 점을 표시합니다.
     
     2. 나침반 버튼 (VStack - Spacer - Button)
        - 화면 우측 하단에 배치합니다.
        - 클릭 시 `viewModel.moveToCurrentLocation()`을 호출합니다.
     */


// MARK: - Preview
/*
 JourneyModel.mocks 데이터를 주입하여 핀이 잘 찍히는지 확인합니다.
 */
