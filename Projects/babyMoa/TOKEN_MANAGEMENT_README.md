# 🔐 토큰 관리 시스템 가이드

## 📋 개요

이 앱은 **AccessToken + RefreshToken** 방식으로 인증을 관리합니다.

### 토큰 종류

1. **AccessToken** (짧은 수명, 1시간)
   - API 요청 시 사용
   - KeyChain에 안전하게 저장
   - 만료되면 자동으로 RefreshToken으로 갱신

2. **RefreshToken** (긴 수명, 2주~30일)
   - AccessToken 재발급 전용
   - KeyChain에 안전하게 저장

---

## 🏗️ 구조

```
Manager/
  ├── TokenManager.swift          # 토큰 관리 전담 클래스
  └── AppState.swift               # 앱 전역 상태 (토큰 저장/로드)

Services/
  └── APIService.swift             # 아기 API (자동 토큰 갱신)

Network/
  └── MemoryAPIClient.swift        # 추억 API (자동 토큰 갱신)
```

---

## 🔄 토큰 흐름

### 1️⃣ 로그인/회원가입

```swift
AppState.signIn(with: authorization)
  ↓
identityToken 받음 (Apple Sign In)
  ↓
TokenManager.saveAccessToken(identityToken)
  ↓
KeyChain에 안전하게 저장
```

### 2️⃣ API 요청

```swift
API 요청 시도
  ↓
TokenManager.loadAccessToken()
  ↓
Authorization 헤더에 "Bearer {token}" 추가
  ↓
서버로 요청 전송
```

### 3️⃣ 토큰 만료 처리 (자동)

```swift
API 응답: 401 Unauthorized
  ↓
TokenManager.refreshAccessToken() 자동 호출
  ↓
RefreshToken으로 새 AccessToken 요청
  ↓
성공 → 새 토큰 저장 → 원래 요청 재시도
실패 → 로그아웃 (재로그인 필요)
```

---

## 📝 주요 클래스

### TokenManager.swift

모든 토큰 관련 작업을 담당합니다.

```swift
// 토큰 저장
TokenManager.shared.saveAccessToken("new_token")
TokenManager.shared.saveRefreshToken("refresh_token")

// 토큰 로드
let accessToken = TokenManager.shared.loadAccessToken()
let refreshToken = TokenManager.shared.loadRefreshToken()

// 토큰 갱신 (자동)
let newToken = try await TokenManager.shared.refreshAccessToken()

// 로그아웃 (모든 토큰 삭제)
TokenManager.shared.clearAllTokens()
```

### APIService.swift & MemoryAPIClient.swift

401 오류 발생 시 **자동으로 토큰 갱신 후 재시도**합니다.

```swift
// 1차 시도
API 요청 (AccessToken 포함)
  ↓
401 Unauthorized?
  ↓
// 자동 토큰 갱신
TokenManager.retryWithRefreshedToken(originalRequest)
  ↓
// 2차 시도 (새 토큰)
API 재요청
  ↓
성공 → 응답 반환
```

---

## ⚙️ 백엔드 연동 필요사항

### 1. RefreshToken 엔드포인트

```http
POST /api/auth/refresh
Content-Type: application/json

{
  "refreshToken": "your_refresh_token"
}
```

**응답 (성공):**
```json
{
  "success": true,
  "accessToken": "new_access_token",
  "refreshToken": "new_refresh_token"  // (선택적)
}
```

**응답 (RefreshToken 만료):**
```json
{
  "success": false,
  "errorCode": "REFRESH_TOKEN_EXPIRED",
  "message": "Refresh token expired"
}
```

### 2. AccessToken 만료 응답

모든 API에서 AccessToken이 만료되면 **401 Unauthorized** 반환

```json
{
  "success": false,
  "errorCode": "TOKEN_EXPIRED",
  "message": "Access token expired"
}
```

---

## 🔧 TODO (백엔드 연동 후 수정 필요)

### TokenManager.swift

1. **baseURL 변경** (14번 줄)
   ```swift
   private let baseURL = "https://api.example.com/v1"
   // ↓ 실제 백엔드 URL로 변경
   private let baseURL = "https://your-backend-api.com/v1"
   ```

2. **RefreshToken 엔드포인트 경로 확인** (77번 줄)
   ```swift
   guard let url = URL(string: "\(baseURL)/auth/refresh") else {
   // ↓ 백엔드 스펙에 맞게 수정
   ```

### AppState.swift

1. **Apple Sign In 후 RefreshToken 저장** (62-63번 줄)
   ```swift
   // TODO: 백엔드에서 RefreshToken도 받으면 저장
   // TokenManager.shared.saveRefreshToken(refreshToken)
   ```

   백엔드에서 Apple Sign In 성공 시 RefreshToken도 함께 반환하면:
   ```swift
   TokenManager.shared.saveRefreshToken(refreshToken)
   ```

---

## 🛡️ 보안

1. **KeyChain 사용**
   - 모든 토큰은 KeyChain에 안전하게 저장
   - 앱 삭제 시에도 데이터 유지 (선택 가능)

2. **자동 갱신**
   - 사용자가 직접 처리할 필요 없음
   - 401 오류 발생 시 자동으로 갱신 후 재시도

3. **로그아웃**
   - `TokenManager.clearAllTokens()` 호출 시 모든 토큰 삭제

---

## 🎯 테스트 방법

### 1. 토큰 저장 확인
```swift
print(TokenManager.shared.loadAccessToken())
// 출력: Optional("eyJhbGc...")
```

### 2. 토큰 갱신 테스트
- 인위적으로 401 응답을 받도록 설정
- 자동으로 RefreshToken API 호출되는지 확인
- 콘솔에 "🔄 [TokenManager] AccessToken 갱신 시도..." 출력 확인

### 3. 만료된 RefreshToken 테스트
- RefreshToken을 잘못된 값으로 변경
- API 호출 시 로그아웃 처리되는지 확인

---

## 📞 문의

- 토큰 관련 문제 발생 시 백엔드 개발자와 협의
- API 스펙 변경 시 이 문서도 업데이트 필요


