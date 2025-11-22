/*
 
 JourneyModel (핵심)

 역할: 서버에서 받아온 여정 데이터의 표준 규격입니다.

 필수 속성:

 id: 데이터 고유 식별자.

 imageURL: UIImage가 아닌 String 타입의 이미지 주소. (메모리 절약의 핵심)

 coordinate: 지도 표시를 위한 위도/경도 (latitude, longitude).

 date: 달력 표시 및 정렬 기준.

 제약 사항: 비즈니스 로직이나 이미지 다운로드 코드를 절대 포함하지 않습니다
 
 [책임과 역할 (Responsibilities)]
  1. 서버 API 응답(JSON)을 앱 내에서 사용할 수 있는 구조체로 변환합니다. (Codable)
  2. 리스트(List)나 지도(Map)에서 고유하게 식별될 수 있어야 합니다. (Identifiable)
  3. 데이터의 변경 사항을 감지하거나 비교할 수 있어야 합니다. (Hashable)
  4. UI 개발 및 테스트를 위한 '가짜 데이터(Mock Data)'를 제공합니다.
  
  [설계 원칙 (Design Principles)]
  1. **절대 금지**: `UIImage` 타입의 이미지를 직접 포함하지 않습니다. (메모리 이슈 방지)
  2. **이미지 처리**: 오직 서버상의 이미지 주소인 `String` 타입의 URL만 저장합니다.
  3. **로직 배제**: 데이터를 가공하거나 비즈니스 로직을 포함하지 않는 순수한 데이터 객체(DTO)여야 합니다.
  4. **좌표 변환**: 지도 라이브러리(MapKit) 사용 편의를 위해 `coordinate` 계산 속성을 제공합니다.
 
 
 
 */


// MARK: - 1. Core Properties (서버 데이터 매핑)
    /*
     서버 DB의 컬럼과 1:1로 매칭되는 속성들입니다.
     - journeyId: 고유 식별자 (Int)
     - imageURL: S3 등에 저장된 이미지의 웹 URL (String)
     - date: 여정이 기록된 날짜 (Date)
     - memo: 사용자가 작성한 메모 내용 (String)
     - latitude: 위도 (Double)
     - longitude: 경도 (Double)
     */
    
    
    // MARK: - 2. Helper Properties (편의 기능)
    /*
     뷰(View)에서 사용하기 편하도록 가공된 속성입니다.
     - id: Identifiable 프로토콜 준수용 (journeyId를 리턴)
     - coordinate: MapKit의 Annotation에 바로 넣을 수 있는 CLLocationCoordinate2D 객체
     */
    
    
    // MARK: - 3. Mock Data (UI 테스트용)
    /*
     서버가 없어도 화면을 그릴 수 있도록 제공하는 샘플 데이터입니다.
     `static let mocks: [JourneyModel]` 형태로 정의하며,
     배열 안에 5~10개의 더미 데이터를 직접 하드코딩해서 넣어둡니다.
     이미지 URL은 "https://picsum.photos/..." 같은 무료 이미지 호스팅 주소를 사용합니다.
     */
