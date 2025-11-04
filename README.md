# 🚀 프로젝트 이름

![배너 이미지 또는 로고](링크)

> 놓치기 쉬운 아이와의 소중한 순간들을 간편하게 기록하여, 추억을 되새길 수 있도록 도와주는 앱 BabyMoA

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)]()
[![Xcode](https://img.shields.io/badge/Xcode-15.0-blue.svg)]()
[![License](https://img.shields.io/badge/license-MIT-green.svg)]()

---

## 🗂 목차
- [소개](#소개)
- [프로젝트 기간](#프로젝트-기간)
- [기술 스택](#기술-스택)
- [기능](#기능)
- [시연](#시연)
- [폴더 구조](#폴더-구조)
- [팀 소개](#팀-소개)
- [Git 컨벤션](#git-컨벤션)
- [테스트 방법](#테스트-방법)
- [프로젝트 문서](#프로젝트-문서)
- [라이선스](#lock_with_ink_pen-license)

---

## 📱 소개

“아이들에게 당신이 줄 수 있는 가장 큰 선물은 당신의 시간이다. 그리고 당신이 당신 자신에게 줄 수 있는 가장 큰 선물 가운데 하나는 아이들과 즐거운 시간을 보내면서 그들을 있는 그대로 보는 것이다”
로빈 샤르마 <내가 죽을때 누가 울어줄까>
아이가 우리와 함께하는 세상, 그리고 초보 부모가 아이와 함께하는 세상은 모두가 낯설고 서툰 여정의 시작일 것입니다.
서툰 여정을 아이와 함께 하다보면, 때로는 하루하루 다르게 성장하고 있는 아이의 하루를 놓칠수도 있어요.
BabyMoA를 통해 우리 아이가 매순간 이루어낼 다양한 첫번째 경험들을 함께 준비하고, 추억하세요.
서툴고 어렵기만한 육아 여정에서 부모님들의 곁에 함께하며 든든한 추억 동반자가 되고자 합니다.

[🔗 앱스토어/웹 링크](https://example.com)


## 📆 프로젝트 기간
- 전체 기간: `2025.09.01 - 2025.11.27`
- 개발 기간: `2025.10.20 - 2025.11.27`


## 🛠 기술 스택
- Swift / SwiftUI / UIKit / AWS S3, Java, Spring, Node.js, SwiftData, MySQL 등
- 아키텍처: MVVM / MVC / Clean Architecture 등
- 기타 도구: Figma, Notion, Keynote, GitHub Projects 등


## 🌟 주요 기능
아이의 하루를 모아 추억할 수 있게, 베이비모아는 아이의 개월수에 초점을 맞추었습니다.
- ✅ 기능 1 : 아이의 첫 성장 여정을 준비하고 기록하는, 성장
원더윅스 기반의 아기 성장 여정을 살펴보고 기록하여, 소중한 순간들을 모아 추억하세요.
- ✅ 기능 2 : 다둥이 육아시에도 각 아이별 첫 순간들을 모아 관리할 수 있는, 아기 
편하고 빠른 아기 전환 모드를 통해, 다둥이 육아시에도 각 아이별 소중한 순간을 모아보세요.


## 🖼 화면 구성 및 시연

| 기능 | 설명 | 이미지 |
|------|------|--------|
| 예시1 | 기능 요약 | ![gif](링크) |
| 예시2 | 기능 요약 | ![gif](링크) |


## 🧱 폴더 구조

```
📦ProjectName
┣ 📂Feature
┃ ┣ 📂SceneA
┃ ┗ 📂SceneB
┣ 📂Core
┣ 📂UI
┣ 📂Test
┗ 📂Resources
```


## 🧑‍💻 팀 소개

| 이름 | 역할 | GitHub |
|------|------|--------|
| 홍길동 | iOS Developer | [@hong](https://github.com/hong) |
| 김개발 | PM | [@devkim](https://github.com/devkim) |

[🔗 팀 블로그 / 미디엄 링크](https://medium.com/example)

## 🔖 브랜치 전략
`(예시)`
- `main`: 배포 가능한 안정 버전
- `develop`: 통합 개발 브랜치
- `feature/*`: 기능 개발 브랜치
- `bugfix/*`: 버그 수정 브랜치
- `hotfix/*`: 긴급 수정 브랜치

- 모든 PR은 `develop` 브랜치로 머지됩니다.
- 새로운 브랜치 생성 시 `develop` 브랜치에서 분기합니다.
- 브랜치 이름은 다음 형식을 따릅니다:
  - 기능 개발: `feature/이슈번호` (예: feature/123)
  - 버그 수정: `fix/이슈번호` (예: fix/456)
  - 리팩토링: `refactor/설명` (예: refactor/code-cleanup)
- `main` 브랜치로의 머지는 `develop` 브랜치에서만 가능합니다.
- `main`과 `develop` 브랜치에는 직접 커밋할 수 없습니다.
- `main` 브랜치로의 PR 생성 시, `develop`에 머지된 PR 목록을 상세히 기재합니다.


## 🔖 PR 가이드
- type: feat, fix, docs, style, refactor, test, chore
- 내용 요약: 변경사항을 간단명료하게 설명

예시:
- feat: 아기 성장 기록 기능 추가
- fix: 메모리 누수 문제 해결
- docs: README 업데이트
- refactor: 데이터 모델 구조 정리

| Type      | 설명                                                                 | 사용 예시 |
|-----------|----------------------------------------------------------------------|-----------|
| **feat**  | 새로운 기능 추가                                                      | 로그인 기능 구현, 새로운 버튼 추가 |
| **fix**   | 버그 수정                                                             | 잘못된 값 출력 수정, 크래시 해결 |
| **docs**  | 문서만 수정                                                           | README 업데이트, 주석 보강 |
| **style** | 코드 의미에는 영향 없고, 스타일/포맷만 수정                           | 들여쓰기 정리, 세미콜론 누락 수정 |
| **refactor** | 기능 변화는 없지만 코드 구조 개선                                  | 중복 코드 제거, 함수 분리 |
| **test**  | 테스트 코드 추가/수정                                                 | 단위 테스트 추가, 기존 테스트 보강 |
| **chore** | 빌드, 패키지, 환경설정 등 유지보수 작업 (코드/기능에 영향 없음)      | 의존성 업데이트, CI 설정 수정 |


### PR 설명 형식

Closes #이슈 번호

Description
- 변경사항에 대한 상세 설명

Changes
- 구현한 기능 목록
- 수정된 파일 목록

Test Checklist
- [ ] 테스트 항목 1
- [ ] 테스트 항목 2

Screenshot
<img src="이미지_URL" alt="대체 텍스트" width="200">

Etc.
- 추가 공유건 1
- 추가 공유건 2
- Screenshot은 UI 변경 사항이 있을 때에만 첨부합니다.



## 🌀 커밋 메시지 컨벤션
`(예시)`  
[Gitmoji](https://gitmoji.dev) + [Conventional Commits](https://www.conventionalcommits.org)
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- type: feat, fix, docs, style, refactor, test, chore
- 제목과 본문은 한글로 작성해주세요.
- type은 영어로 작성해주세요.
- 커밋 로그를 보고 흐름을 이해할 수 있도록 작성해주세요.


### 코드 리뷰 규칙
- 왜 개선이 필요한지 이유를 충분한 설명해주세요.


## ✅ 테스트 방법

1. 이 저장소를 클론합니다.
```bash
git clone https://github.com/yourteam/project.git
```
2. `Xcode`로 `.xcodeproj` 또는 `.xcworkspace` 열기
3. 시뮬레이터 환경 설정: iPhone 15 / iOS 17
4. `Cmd + R`로 실행 / `Cmd + U`로 테스트 실행


## 📎 프로젝트 문서

- [기획 히스토리](링크)
- [디자인 히스토리](링크)
- [기술 문서 (아키텍처 등)](링크)


## 📝 License

This project is licensed under the ~~[CHOOSE A LICENSE](https://choosealicense.com). and update this line~~
