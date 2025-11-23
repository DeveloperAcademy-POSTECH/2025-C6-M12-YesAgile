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
    
    // MARK: - Nested Types (For Transferable)
    enum TransferError: Error {
        case importFailed
    }
    
    struct ImageSnippet: Transferable {
        let image: UIImage
        let data: Data // EXIF 추출을 위해 원본 데이터도 유지
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                // UIImage와 원본 Data를 함께 반환
                return ImageSnippet(image: uiImage, data: data)
            }
        }
    }

    // MARK: - Methods
    
    func handleImageSelection(_ item: PhotosPickerItem?) {
        guard let item = item else { return }

        Task {
            do {
                // Transferable을 사용하여 이미지와 데이터(EXIF용) 로드
                if let snippet = try await item.loadTransferable(type: ImageSnippet.self) {
                    self.selectedImage = snippet.image
                    
                    // EXIF에서 위치 정보 추출
                    if let location = ImageEXIFHelper.extractLocation(from: snippet.data) {
                        self.extractedLocation = location
                        self.showLocationAlert = false
                    } else {
                        // EXIF 없으면 위치 없음으로 처리 (현재 위치 사용 안 함)
                        self.extractedLocation = nil
                        self.showLocationAlert = true // "위치 정보가 없습니다" 알림
                        print("📍 [JourneyAddVM] No EXIF location found. Alerting user.")
                    }
                } else {
                    // nil 반환 시 에러 처리
                    throw TransferError.importFailed
                }
                
            } catch {
                print("❌ [JourneyAddVM] Image load failed: \(error.localizedDescription)")
                // 에러 메시지 명확화
                self.loadErrorMessage = "사진을 불러올 수 없습니다.\niCloud 사진인 경우 다운로드 후 다시 시도해주세요."
                self.showLoadErrorAlert = true
            }
        }
    }
}
