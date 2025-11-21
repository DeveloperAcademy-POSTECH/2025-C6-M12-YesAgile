//
//  ImageLoaderViewModel.swift
//  BabyMoa
//
//  Created by Baba on 11/7/25.
//
//

import Foundation
import PhotosUI
import SwiftUI

// MARK: - Image Loading State

/// 이미지 로딩의 현재 상태를 나타내는 열거형입니다.
enum ImageState {
    /// 초기 상태 또는 이미지가 없는 상태입니다.
    case empty
    /// 이미지를 로드 중인 상태이며, Progress 객체를 통해 진행 상태를 추적할 수 있습니다.
    case loading(Progress)
    /// 이미지 로드에 성공했으며, 결과물인 UIImage/NSImage를 포함합니다.
    #if os(iOS)
    case success(UIImage)
    #elseif os(macOS)
    case success(NSImage)
    #endif
    /// 이미지 로드에 실패했으며, 발생한 Error를 포함합니다.
    case failure(Error)
}

/// PhotosPicker로부터 이미지를 선택하고 로드하는 과정을 관리하는 `ObservableObject`입니다.
///
/// 이 ViewModel은 다음과 같은 역할을 수행합니다:
/// 1. SwiftUI의 `PhotosPicker`와 `imageSelection` 프로퍼티를 바인딩합니다.
/// 2. 사진이 선택되면 `didSet`을 통해 이미지 로드를 자동으로 시작합니다.
/// 3. `imageState`를 통해 뷰에게 현재 로딩 상태(.empty, .loading, .success, .failure)를 알립니다.
/// 4. 로드에 성공하면 `imageToUpload` 프로퍼티에 최종 `UIImage`를 저장하여 다른 ViewModel이나 뷰에서 사용할 수 있도록 합니다.
class ImageLoaderViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 현재 이미지 로딩 상태를 실시간으로 게시합니다. (View에서 이 상태에 따라 분기 처리)
    @Published var imageState: ImageState = .empty
    
    /// 로딩이 성공했을 때, 상위 뷰 또는 ViewModel로 전달할 최종 `UIImage` 객체입니다.
    /// `AddBabyViewModel`의 `onChange` 수식어에서 이 값을 관찰합니다.
    @Published var imageToUpload: UIImage?
    
    /// 이미지 로딩 중에 로딩 인디케이터(예: `ProgressView`)를 표시할지 여부를 결정합니다.
    @Published var showLoadingView = false
    
    /// 이미지 로드 성공 후, 미리보기(예: 크롭 뷰)를 표시할지 여부를 결정합니다. (현재 코드에서는 true로 설정만 됨)
    @Published var showPreview = false
    
    /// SwiftUI `PhotosPicker`와 직접 바인딩되는 `PhotosPickerItem`입니다.
    /// 사용자가 사진을 선택하거나 선택을 취소하면 이 프로퍼티가 업데이트됩니다.
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            // `imageSelection`에 새로운 값이 할당되면(사진 선택 시)
            if let imageSelection {
                // 1. `loadTransferable`을 호출하여 비동기 로드를 시작합니다.
                let progress = loadTransferable(from: imageSelection)
                // 2. 뷰가 로딩 상태임을 알립니다.
                imageState = .loading(progress)
                showLoadingView = true
            } else {
                // `imageSelection`이 nil이 되면(선택 취소 또는 초기화 시)
                // 1. 모든 상태를 초기화합니다.
                imageState = .empty
                showLoadingView = false
            }
        }
    }
    
    // MARK: - Nested Types (Error & Transferable)
    
    /// 이미지 데이터 변환 중 발생할 수 있는 커스텀 에러입니다.
    enum TransferError: Error {
        case importFailed
    }
    
    /// `PhotosPickerItem`에서 `UIImage`로 데이터를 변환하기 위한 `Transferable` 프로토콜 준수 구조체입니다.
    /// `loadTransferable(type:)` 메서드에서 이 타입을 사용합니다.
    struct ImageSnippet: Transferable {
        
        #if os(iOS)
        let image: UIImage
        #elseif os(macOS)
        let image: NSImage
        #endif
        
        /// `PhotosPicker`가 선택된 항목을 어떻게 `ImageSnippet`으로 변환할지 정의합니다.
        static var transferRepresentation: some TransferRepresentation {
            // `.image` 콘텐츠 타입의 데이터를 가져옵니다.
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                // macOS용 코드
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                return ImageSnippet(image: nsImage)
            #elseif canImport(UIKit)
                // iOS용 코드
                guard let uiImage = UIImage(data: data) else {
                    print("DEBUG: import image conversion failed")
                    throw TransferError.importFailed
                }
                return ImageSnippet(image: uiImage)
            #else
                // 지원되지 않는 플랫폼
                throw TransferError.importFailed
            #endif
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// `PhotosPickerItem`에서 `ImageSnippet` 타입으로 이미지를 비동기적으로 로드합니다.
    /// - Parameter imageSelection: 사용자가 선택한 `PhotosPickerItem`
    /// - Returns: 로드 과정을 추적할 수 있는 `Progress` 객체
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        // `imageSelection.loadTransferable`을 호출하고 완료 핸들러(클로저)를 제공합니다.
        return imageSelection.loadTransferable(type: ImageSnippet.self) { result in
            
            // 로드가 완료되면(성공/실패 무관), UI 업데이트를 위해 메인 스레드로 전환합니다.
            DispatchQueue.main.async {
                
                // [안전장치]
                // 만약 로드가 완료되었을 때의 `imageSelection`이
                // 현재 `self.imageSelection`과 다르다면(즉, 그 사이에 사용자가 다른 사진을 선택했다면),
                // 이 로드 결과는 무시합니다.
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                
                // 로드 결과를 `switch` 문으로 처리합니다.
                switch result {
                case .success(let snippetImage?):
                    // (성공) snippetImage가 성공적으로 로드됨
                    self.showLoadingView = false
                    self.imageState = .success(snippetImage.image)
                    self.imageToUpload = snippetImage.image // <- 이 값이 .onChange에서 감지됩니다.
                    self.showPreview = true // (필요시 사용)
                    
                case .success(nil):
                    // (성공했으나 nil) 사용자가 선택을 완료하지 않았거나 항목이 비어있을 수 있습니다.
                    self.showLoadingView = false
                    self.imageState = .empty
                    
                case .failure(let error):
                    // (실패) 로드 중 에러 발생
                    self.imageState = .failure(error)
                }
            }
        }
    }
}

// MARK: - 📖 사용법 (Usage in AddBabyStatusView)

/// 이 `ImageLoaderViewModel`은 `AddBabyStatusView`와 같이 사진 선택 기능이 필요한 뷰에서 다음과 같이 사용됩니다.
///
/// **1. 뷰 모델 생성**
/// `AddBabyStatusView` 내부에 `@StateObject`로 `ImageLoaderViewModel`의 인스턴스를 생성합니다.
/// ```swift
/// @StateObject private var imageLoaderViewModel = ImageLoaderViewModel()
/// ```
///
/// **2. PhotosPicker 바인딩**
/// `AddBabyStatusView`의 `.photosPicker` 수식어에 `ImageLoaderViewModel`의 프로퍼티를 바인딩합니다.
/// - `isPresented:`: 사진 라이브러리를 띄울지 여부 (이것은 메인 ViewModel인 `AddBabyViewModel`의 `@Published var showLibrary`가 관리합니다.)
/// - `selection:`: 사용자가 선택한 항목을 `imageLoaderViewModel`의 `imageSelection` 프로퍼티에 바인딩합니다.
///
/// ```swift
/// .photosPicker(
///     isPresented: $viewModel.showLibrary, // 메인 ViewModel이 관리
///     selection: $imageLoaderViewModel.imageSelection, // ImageLoaderViewModel이 관리
///     matching: .images,
///     photoLibrary: .shared()
/// )
/// ```
///
/// **3. 이미지 로드 자동 실행**
/// 사용자가 사진을 선택하면, `selection:`에 바인딩된 `imageLoaderViewModel.imageSelection` 프로퍼티가 업데이트됩니다.
/// 이 프로퍼티의 `didSet` 블록이 자동으로 실행되어 `loadTransferable(from:)` 함수를 호출, 이미지 로드를 시작합니다.
///
/// **4. 로드 완료 감지 및 이미지 전달**
/// `ImageLoaderViewModel`이 이미지 로드를 완료하면, `imageToUpload` 프로퍼티에 `UIImage`를 할당합니다.
/// `AddBabyStatusView`는 이 `imageToUpload` 프로퍼티의 변경을 `.onChange` 수식어로 감지합니다.
///
/// ```swift
/// .onChange(of: imageLoaderViewModel.imageToUpload) { _, newValue in
///     if let newValue = newValue {
///         // 5. 최종 이미지를 메인 ViewModel (AddBabyViewModel)에 전달합니다.
///         viewModel.displayedProfileImage = Image(uiImage: newValue)
///         viewModel.profileImage = newValue // 업로드용 원본 UIImage
///     }
/// }
/// ```
///
/// **요약:** `AddBabyStatusView`는 메인 `ViewModel`을 통해 피커를 **띄우고**, `ImageLoaderViewModel`을 통해 사진을 **선택 및 로드**하며, `.onChange`를 통해 로드된 이미지를 다시 메인 `ViewModel`로 **전달**받는 구조입니다.
