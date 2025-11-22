//
//  JourneyAddViewModel.swift
//  babyMoa
//
//  Created by pherd on 11/20/25.
//

import CoreLocation
import PhotosUI
import SwiftUI
//
//@MainActor
//@Observable class JourneyAddViewModel {
//    // MARK: - Properties
//    var selectedImage: UIImage?
//    var memo: String
//    var extractedLocation: CLLocation?
//
//    // View State
//    var showLocationAlert = false
//    var showLoadErrorAlert = false
//    var loadErrorMessage = ""
//    var imageWasEdited = false
//
//    // Private Properties
//    private let existingJourney: Journey?
//    private let onSave: (UIImage, String, Double, Double) -> Void
//
//    init(
//        existingJourney: Journey? = nil,
//        onSave: @escaping (UIImage, String, Double, Double) -> Void
//    ) {
//        self.existingJourney = existingJourney
//        self.onSave = onSave
//
//        if let existing = existingJourney {
//            self.selectedImage = existing.journeyImage
//            self.memo = existing.memo
//            self.extractedLocation = CLLocation(latitude: existing.latitude, longitude: existing.longitude)
//        } else {
//            self.memo = ""
//        }
//    }
//
//    // MARK: - Computed Properties
//    var hasChanges: Bool {
//        guard let original = existingJourney else { return true }
//        let imgChanged = imageWasEdited
//        let memoChanged = memo != original.memo
//        let locChanged = extractedLocation?.coordinate.latitude != original.latitude || extractedLocation?.coordinate.longitude != original.longitude
//        return imgChanged || memoChanged || locChanged
//    }
//
//    var isSaveDisabled: Bool {
//        selectedImage == nil || !hasChanges
//    }
//
//    var navigationTitle: String {
//        existingJourney != nil ? "여정 수정" : ""
//    }
//
//    // MARK: - Actions
//    
//    func save() {
//        guard let image = selectedImage else { return }
//        let latitude = extractedLocation?.coordinate.latitude ?? 0.0
//        let longitude = extractedLocation?.coordinate.longitude ?? 0.0
//        onSave(image, memo, latitude, longitude)
//    }
//
//    func handleImageSelection(_ newItem: PhotosPickerItem?) {
//        guard let newItem else { return }
//        Task {
//            do {
//                guard let data = try await newItem.loadTransferable(type: Data.self) else {
//                    loadErrorMessage = "사진을 불러올 수 없습니다.\n다른 사진을 선택해주세요."
//                    showLoadErrorAlert = true
//                    return
//                }
//                guard let uiImage = UIImage(data: data) else {
//                    loadErrorMessage = "사진 형식을 인식할 수 없습니다.\n다른 사진을 선택해주세요."
//                    showLoadErrorAlert = true
//                    return
//                }
//                
//                selectedImage = uiImage
//                imageWasEdited = existingJourney != nil
//
//                if let location = ImageEXIFHelper.extractLocation(from: data) {
//                    extractedLocation = location
//                } else {
//                    extractedLocation = CLLocation(latitude: 0, longitude: 0)
//                    showLocationAlert = true
//                }
//            } catch {
//                loadErrorMessage = "사진을 불러오는 중 오류가 발생했습니다.\n(\(error.localizedDescription))"
//                showLoadErrorAlert = true
//            }
//        }
//    }
//}
