//
//  JourneyAddViewModel.swift
//  babyMoa
//
//  Created by pherd on 11/11/25.
//  Refactored on 11/22/25
//

import SwiftUI
import CoreLocation
import PhotosUI

@MainActor
@Observable
final class JourneyAddViewModel {
    // MARK: - Properties
    var selectedImage: UIImage?
    var memo: String = ""
    var extractedLocation: CLLocation?

    // UI State
    var isImagePickerPresented: Bool = false
    var showLocationAlert: Bool = false
    var showLoadErrorAlert: Bool = false
    var loadErrorMessage: String = ""

    // MARK: - Computed Properties
    var isSaveDisabled: Bool {
        selectedImage == nil
    }

    // MARK: - Initialization
    init(journey: Journey? = nil) {
        if let journey = journey {
            self.selectedImage = journey.journeyImage
            self.memo = journey.memo
            self.extractedLocation = CLLocation(latitude: journey.latitude, longitude: journey.longitude)
        }
    }

    // MARK: - Methods
    
    func handleImageSelection(_ item: PhotosPickerItem?) {
        guard let item = item else { return }

        Task {
            do {
                // 1. 이미지 데이터 로드
                if let data = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    
                    self.selectedImage = image
                    
                    // 2. EXIF에서 위치 정보 추출
                    if let location = ImageEXIFHelper.extractLocation(from: data) {
                        self.extractedLocation = location
                        self.showLocationAlert = false // 성공 시 알림 끄기
                    } else {
                        self.extractedLocation = nil
                        self.showLocationAlert = true // 실패 시 알림 켜기
                    }
                    
                } else {
                    self.loadErrorMessage = "이미지를 불러올 수 없습니다."
                    self.showLoadErrorAlert = true
                }
            } catch {
                self.loadErrorMessage = error.localizedDescription
                self.showLoadErrorAlert = true
            }
        }
    }
}
