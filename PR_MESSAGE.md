# 사진 라이브러리 권한 체크 기능 개선

## 📋 변경 사항

### 1. 앱 시작 시 사진 라이브러리 권한 체크 추가
- `BabyMoaRootView`의 `onAppear`에서 사진 라이브러리 권한을 자동으로 체크하도록 구현
- 앱 실행 시점에 권한 상태를 확인하여 사용자 경험 개선

### 2. PermissionManager API 개선
- `checkPhotoLibraryPermission` 메서드의 `authorized`와 `denied` 클로저 파라미터에 기본값(`{}`) 추가
- 클로저를 전달하지 않아도 메서드를 호출할 수 있도록 개선하여 사용성 향상

## 🎯 목적
- 앱 시작 시점에 사진 라이브러리 권한을 사전에 확인하여 권한 관련 이슈를 사전에 방지
- 권한 체크 메서드의 사용성을 개선하여 더 유연하게 활용 가능하도록 개선

## 📝 변경된 파일
- `Projects/BabyMoa/babyMoa/App/BabyMoaRoot/BabyMoaRootView.swift`
- `Projects/BabyMoa/babyMoa/Manager/PermissionManager.swift`

