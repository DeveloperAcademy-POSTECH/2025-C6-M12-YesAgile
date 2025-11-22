/*
 ===================================================================================
 [File Name] : JourneyAddViewModel.swift
 [Role]      : 여정 추가/수정 화면의 입력 상태 관리 및 유효성 검사
 [Layer]     : ViewModel (Form Logic)
 ===================================================================================
 
 [핵심 책임 (Core Responsibilities)]
 1. **Form State**: 사용자가 입력 중인 메모, 선택한 날짜, 선택한 이미지를 임시 저장합니다.
 2. **Validation**: "저장" 버튼을 누를 수 있는지(이미지가 있는지 등) 판단합니다.
 3. **Formatting**: 선택한 이미지(PhotosPickerItem)를 데이터로 변환하거나, 위치 정보(EXIF)를 추출합니다.
 
 [설계 의도 및 이유 (Why)]
 1. 왜 메인 뷰모델과 분리했는가?
 - '입력 중인 데이터'는 저장이 완료되기 전까지는 메인 데이터(`allJournies`)에 섞이면 안 됩니다.
 - 폼 화면이 닫히면 이 데이터들은 사라져야 하므로, 수명 주기가 다른 별도 뷰모델이 필요합니다.
 */


// MARK: - 1. State (입력 폼 상태)
/*
 - selectedImage: UIImage? (선택된 사진 프리뷰용)
 - imageItem: PhotosPickerItem? (갤러리 선택 아이템)
 - date: Date (선택된 날짜)
 - memo: String (입력된 메모)
 - location: CLLocationCoordinate2D? (사진에서 추출하거나 선택한 위치)
 */

// MARK: - 2. Initializer
/*
 - init(journey: JourneyModel? = nil)
 * 수정 모드일 경우 기존 데이터를 폼에 채워 넣습니다.
 * 추가 모드일 경우 빈 상태로 시작합니다.
 */

// MARK: - 3. Actions
/*
 [handleImageSelection()]
 - PhotosPickerItem이 변경되면 이미지를 로드하고, EXIF에서 위치 정보를 추출합니다.
 */

/*
 [isValid -> Bool]
 - 이미지가 선택되었는지 확인하여 저장 버튼 활성화 여부를 결정합니다.
 */
