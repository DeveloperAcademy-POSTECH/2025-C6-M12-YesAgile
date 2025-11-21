//
//  JourneyViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//
import Foundation
import SwiftUI

@MainActor
@Observable class JourneyViewModel {
    /// 여정 데이터 배열
    var journies: [Journey] = []

    // MARK: - babyId 동기화 새 아기 동기화 .. 그 아기가 변경되어도 journeyView에서 한번 호출해주면 괜춘!!

    /// SelectedBabyState에서 babyId를 동기화
    /// - Note: MainTabViewModel이 SelectedBabyState에 아기 정보를 설정하면,
    ///         여기서 SelectedBaby.babyId에 동기화 (API 호출 시 필요)
    func syncBabyId() {
        if let baby = SelectedBabyState.shared.baby {
            SelectedBaby.babyId = baby.babyId
        } else {
            print("⚠️ SelectedBabyState.shared.baby가 nil")
        }
    }

    /// 여정 추가
    func addJourney(
        image: UIImage,
        memo: String,
        date: Date,
        latitude: Double,
        longitude: Double
    ) async -> Bool {
        // 1. babyId 확인: MainTabViewModel에서 설정한 현재 아기 ID 가져오기 ToDo 여기서 가져올것인가 동기화 시킬것인가? JourneyView에서 동기화 시키고있음..
        guard let babyId = SelectedBaby.babyId else {
            print("⚠️ babyId 없음")
            return false
        }

        // 2. UIImage 리사이즈: 1024x1024로 제한하여 배터리/메모리 최적화 (원본 대비 약 1/4~1/10)
        let resizedImage = ImageManager.shared.resizeImage(image, maxSize: 1024)

        // 3. UIImage → Base64 변환: 서버 전송을 위해 이미지를 문자열로 인코딩
        // (ImageManager.swift 참고: JPEG Data → Base64 String 변환)
        guard
            let base64Image = ImageManager.shared.encodeToBase64(
                resizedImage,
                compressionQuality: 0.7
            )
        else {
            print("❌ 이미지 Base64 변환 실패")
            return false
        }

        // 4. 서버에 여정 추가 API 호출
        let result = await BabyMoaService.shared.postAddJourney(
            babyId: babyId,
            journeyImage: base64Image,
            latitude: latitude,
            longitude: longitude,
            date: DateFormatter.yyyyDashMMDashdd.string(from: date),
            memo: memo
        )

        // 5. 서버 응답 처리 및 로컬 배열 업데이트 (Server-First 방식)
        switch result {
        case .success(let response):
            // 서버에서 생성된 journeyId 포함한 데이터 받아오기
            if let data = response.data {
                // 새 여정 객체 생성 (서버 ID + 로컬 이미지 조합)
                let newJourney = Journey(
                    journeyId: data.journeyId,
                    journeyImage: resizedImage,  // 리사이즈된 이미지 재사용
                    latitude: latitude,
                    longitude: longitude,
                    date: date,
                    memo: memo
                )
                // 배열에 추가 후 최신순 정렬 (날짜 기준 내림차순)
                // ✅ 로컬 배열(journies)에 직접 추가 (추가할 때마다 전체 목록을 다시 조회(Fetch)하지 않음)
                journies.append(newJourney)
                journies.sort { firstJourney, secondJourney in
                    firstJourney.date > secondJourney.date
                }
                return true
            }
            print("⚠️ 서버 응답 데이터 없음")
            return false

        case .failure(let error):
            print("❌ 서버 저장 실패: \(error)")
            return false
        }
    }

    /// 여정 수정 (Server-First)
    func updateJourney(
        journey: Journey,
        image: UIImage,
        memo: String,
        latitude: Double,
        longitude: Double
    ) async -> Bool {
        // 1. babyId 확인
        guard let babyId = SelectedBaby.babyId else {
            print("⚠️ babyId 없음")
            return false
        }

        // 2. UIImage 리사이즈 (addJourney와 동일: 1024x1024)
        let resizedImage = ImageManager.shared.resizeImage(image, maxSize: 1024)

        // 3. UIImage → Base64 변환 (addJourney와 동일: 압축률 0.7)
        guard
            let base64Image = ImageManager.shared.encodeToBase64(
                resizedImage,
                compressionQuality: 0.7
            )
        else {
            print("❌ 이미지 Base64 변환 실패")
            return false
        }

        // 4. 서버에 여정 수정 API 호출
        let result = await BabyMoaService.shared.patchUpdateJourney(
            babyId: babyId,
            journeyId: journey.journeyId,
            journeyImage: base64Image,
            latitude: latitude,
            longitude: longitude,
            date: DateFormatter.yyyyDashMMDashdd.string(from: journey.date),
            memo: memo
        )

        // 5. 성공 시 로컬 배열 업데이트
        switch result {
        case .success:
            if let index = journies.firstIndex(where: {
                $0.journeyId == journey.journeyId
            }) {
                journies[index] = Journey(
                    journeyId: journey.journeyId,
                    journeyImage: resizedImage,  // 리사이즈된 이미지 재사용
                    latitude: latitude,
                    longitude: longitude,
                    date: journey.date,
                    memo: memo
                )
            }
            return true
        case .failure(let error):
            print("❌ 여정 수정 실패: \(error)")
            return false
        }
    }

    /// 여정 삭제 (Server-First)
    /// - Parameter journey: 삭제할 여정
    /// - Returns: 성공 여부
    func removeJourney(_ journey: Journey) async -> Bool {
        // 1. babyId 확인: 현재 아기 ID 가져오기
        guard let babyId = SelectedBaby.babyId else {
            print("⚠️ babyId 없음")
            return false
        }

        // 2. 서버에 삭제 API 호출
        let result = await BabyMoaService.shared.deleteJourney(
            babyId: babyId,
            journeyId: journey.journeyId
        )

        // 3. 서버 삭제 성공 시 로컬 배열에서도 제거 (Server-First 방식)
        switch result {
        case .success:
            journies.removeAll { existingJourney in
                existingJourney == journey
            }
            return true

        case .failure(let error):
            print("❌ 서버 삭제 실패: \(error)")
            return false
        }
    }

    // MARK: - Fetch 함수
    /// 특정 날짜의 월 데이터 조회
    /// - Parameter date: 조회할 월이 포함된 날짜
    func fetchJournies(for date: Date) async {
        // 1. babyId 확인: 현재 아기 ID 가져오기
        guard let babyId = SelectedBaby.babyId else {
            print("⚠️ babyId 없음")
            journies = []
            return
        }

        // 2. date에서 연도(year)와 월(month) 추출
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)

        // 3. 서버에서 해당 월의 모든 여정 데이터 조회
        let result = await BabyMoaService.shared.getGetJourniesAtMonth(
            babyId: babyId,
            year: year,
            month: month
        )

        switch result {
        case .success(let response):
            // 서버 응답 데이터 확인
            guard let models = response.data else {
                print("⚠️ response.data가 nil")
                journies = []
                return
            }

            // ResponseModel → Domain Model 변환 (각 모델마다 이미지 다운로드 포함)
            var converted: [Journey] = []
            for model in models {
                let journey = await model.toDomain()
                converted.append(journey)
            }

            // 변환된 여정 배열로 UI 상태 업데이트
            journies = converted

        case .failure(let error):
            print("❌ 여정 조회 실패: \(error)")
            journies = []
        }
    }
}
