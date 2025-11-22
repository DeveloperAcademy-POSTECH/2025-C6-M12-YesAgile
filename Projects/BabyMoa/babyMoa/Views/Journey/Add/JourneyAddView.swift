/*
 ===================================================================================
 [File Name] : JourneyAddView.swift
 [Role]      : 새로운 여정을 기록하거나 기존 여정을 수정하는 화면
 [Layer]     : View (Presentation Layer)
 ===================================================================================
 
 [핵심 책임 (Core Responsibilities)]
 1. **User Input**: 사진 선택(PhotosPicker), 날짜 선택(DatePicker), 메모 입력(TextEditor)을 받습니다.
 2. **Binding**: `JourneyAddViewModel`과 바인딩되어 입력 즉시 상태를 업데이트합니다.
 3. **Action**: 저장 버튼 클릭 시, 완성된 데이터를 부모(Main)에게 전달하여 서버 통신을 요청합니다.
 
 [설계 의도 및 이유 (Why)]
 1. 비유 (Metaphor): "작성 신청서"
 - 이 뷰는 관공서의 '신청서 작성 창구'입니다.
 - 작성이 완료되고 도장이 찍혀야(Save) 비로소 서류 보관함(Main ViewModel)으로 넘어갑니다.
 */


// MARK: - 1. Properties
/*
 [viewModel]
 - `@State`로 선언하여 폼의 상태를 관리합니다.
 */

/*
 [onSave: (UIImage, Date, String, Double, Double) -> Void]
 - 사용자가 '저장'을 눌렀을 때 호출할 클로저입니다.
 - 여기서 데이터를 받아 메인 뷰모델이 서버로 전송합니다.
 */

// MARK: - 2. Body
/*
 [구현 가이드]
 - Form 또는 ScrollView 구조
 - Section 1: 사진 선택 (없으면 Placeholder, 있으면 Image)
 - Section 2: 날짜 선택 (DatePicker)
 - Section 3: 메모 입력 (TextEditor)
 - NavigationBar: '취소', '저장' 버튼 배치
 */
