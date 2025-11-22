//
//  JourneyAddViewModel.swift
//  babyMoa
//
//  Created by pherd on 11/20/25.
//

import CoreLocation
import PhotosUI
import SwiftUI

@MainActor
@Observable class JourneyAddViewModel {
    // MARK: - Properties

    var selectedImage: UIImage?
    var memo: String
    var extractedLocation: CLLocation?

    // View State
    var showLocationAlert = false
    var showLoadErrorAlert = false
    var loadErrorMessage = ""
    var imageWasEdited = false  // 편집 모드에서 새 이미지를 골랐는지 추적

    // Private Properties
    private let existingJourney: Journey?

    // MARK: - Init

    init(existingJourney: Journey? = nil) {
        self.existingJourney = existingJourney

        if let existing = existingJourney {
            self.selectedImage = existing.journeyImage
            self.memo = existing.memo
            self.extractedLocation = CLLocation(
                latitude: existing.latitude,
                longitude: existing.longitude
            )
            self.memo = existing.memo
        } else {
            self.memo = ""
        }
    }

    // MARK: - Computed Properties

    /// 변경 여부 확인 (편집 모드에서만 의미 있음)
    var hasChanges: Bool {
        guard let original = existingJourney else { return true }

        let imgChanged = imageWasEdited
        let memoChanged = memo != original.memo
        let locChanged =
            extractedLocation?.coordinate.latitude != original.latitude
            || extractedLocation?.coordinate.longitude != original.longitude

        return imgChanged || memoChanged || locChanged
    }

    /// 저장 버튼 활성화 여부
    var isSaveDisabled: Bool {
        selectedImage == nil || !hasChanges
    }

    /// 네비게이션 타이틀
    var navigationTitle: String {
        existingJourney != nil ? "여정 수정" : ""  // 날짜는 View에서 처리하거나 여기서 받을 수 있음
    }

    // MARK: - Actions

    /// 이미지 선택 핸들러
    func handleImageSelection(_ newItem: PhotosPickerItem?) {
        guard let newItem else { return }

        Task {
            do {
                print("🔍 이미지 로드 시작...")

                // 1. 이미지 로드
                guard
                    let data = try await newItem.loadTransferable(
                        type: Data.self
                    )
                else {
                    print("❌ Data 로드 실패: loadTransferable returned nil")
                    loadErrorMessage = "사진을 불러올 수 없습니다.\n다른 사진을 선택해주세요."
                    showLoadErrorAlert = true
                    selectedImage = nil
                    extractedLocation = nil
                    return
                }

                guard let uiImage = UIImage(data: data) else {
                    print("❌ UIImage 변환 실패")
                    loadErrorMessage = "사진 형식을 인식할 수 없습니다.\n다른 사진을 선택해주세요."
                    showLoadErrorAlert = true
                    selectedImage = nil
                    extractedLocation = nil
                    return
                }

                print("✅ 이미지 로드 성공 (크기: \(uiImage.size))")
                selectedImage = uiImage
                imageWasEdited = existingJourney != nil  // 편집 모드라면 변경 플래그 설정

                // 2. EXIF에서 위치 정보 추출
                if let location = ImageEXIFHelper.extractLocation(from: data) {
                    print("✅ 위치 정보 추출 성공: \(location.coordinate)")
                    extractedLocation = location
                } else {
                    print("⚠️ 위치 정보 없음 - 기본 위치(0,0) 사용")
                    extractedLocation = CLLocation(latitude: 0, longitude: 0)
                    showLocationAlert = true
                }
            } catch {
                print("❌ 이미지 로드 에러: \(error.localizedDescription)")
                loadErrorMessage =
                    "사진을 불러오는 중 오류가 발생했습니다.\n(\(error.localizedDescription))"
                showLoadErrorAlert = true
                selectedImage = nil
                extractedLocation = nil
            }
        }
    }
}
