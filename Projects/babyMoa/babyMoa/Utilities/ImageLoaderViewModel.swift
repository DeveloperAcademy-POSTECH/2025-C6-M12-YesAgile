//
//  ImageLoaderViewModel.swift
//  BabyMoa
//
//  Created by Baba on 11/7/25.
//
//
//

import Foundation
import PhotosUI
import SwiftUI

// MARK: - Image Loading State

enum ImageState {
    case empty
    case loading(Progress)
    #if os(iOS)
    case success(UIImage)
    #elseif os(macOS)
    case success(NSImage)
    #endif
    case failure(Error)
}

class ImageLoaderViewModel: ObservableObject {
     
    // MARK: - Published Properties
    
    @Published var imageState: ImageState = .empty
    @Published var imageToUpload: UIImage? // 로드 성공 시 업로드할 이미지
    @Published var showLoadingView = false
    @Published var showPreview = false
    
    // PhotosPicker와 바인딩될 아이템
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
                showLoadingView = true
            } else {
                imageState = .empty
                showLoadingView = false
            }
        }
    }
     
    // MARK: - Nested Types (Error & Transferable)
    
    enum TransferError: Error {
        case importFailed
    }
     
    // PhotosPicker에서 데이터를 변환하기 위한 Transferable 구조체
    struct ImageSnippet: Transferable {
         
        #if os(iOS)
        let image: UIImage
        #elseif os(macOS)
        let image: NSImage
        #endif
         
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                return ImageSnippet(image: nsImage)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    print("DEBUG: import image conversion failed")
                    throw TransferError.importFailed
                }
                return ImageSnippet(image: uiImage)
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
     
    // MARK: - Private Methods
    
    /// PhotosPickerItem에서 이미지를 비동기적으로 로드합니다.
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ImageSnippet.self) { result in
            // 메인 스레드에서 UI 업데이트
            DispatchQueue.main.async {
                // 현재 선택된 아이템과 로드 완료된 아이템이 동일한지 확인
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                
                // 로드 결과 처리
                switch result {
                case .success(let snippetImage?):
                    // 성공
                    self.showLoadingView = false
                    self.imageState = .success(snippetImage.image)
                    self.imageToUpload = snippetImage.image
                    self.showPreview = true
                case .success(nil):
                    // 성공했으나 데이터가 없음 (예: 사용자가 취소)
                    self.showLoadingView = false
                    self.imageState = .empty
                case .failure(let error):
                    // 실패
                    self.imageState = .failure(error)
                }
            }
        }
    }
     
}
