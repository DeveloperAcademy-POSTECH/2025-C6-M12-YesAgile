////
////  PhotoViewModel.swift
////  BabyMoaMap
////
////  Created by TaeHyeon Koo on 10/20/25.
////
////  Clean Architecture - ViewModel Layer
////  - UI 상태 관리
////  - Service와 Repository를 통한 데이터 처리
// 잘가라 추억탭
//import Combine
//import CoreLocation
//import Foundation
//import Photos
//import SwiftUI
//
///// @Observable 매크로를 사용한 최신 방식의 ViewModel
///// - iOS 17+부터 사용 가능
///// - @Published 없이도 자동으로 변화 감지
///// - @Bindable을 통해 양방향 바인딩 가능 하다고 합니다~
//@MainActor
//@Observable
//class PhotoViewModel {
//    // MARK: - Observable Properties (자동으로 변화 감지됨)
//    var photos: [LocalPhoto] = []
//    var selectedDate: Date = Date()
//    var currentLocation: CLLocation?
//    var isLoading: Bool = false
//    var errorMessage: String?
//
//    // MARK: - Private Properties
//    private let photoService: PhotoService
//    private let locationManager: LocationManager
//    private var cancellables = Set<AnyCancellable>()
//
//    // MARK: - Initialization
//    init(
//        photoService: PhotoService = PhotoService(),
//        locationManager: LocationManager = LocationManager()
//    ) {
//        self.photoService = photoService
//        self.locationManager = locationManager
//
//        setupBindings()
//        loadPhotos()
//    }
//
//    // MARK: - Public Methods
//
//    /// 사진 추가 (PHAsset 사용)
//    func addPhoto(image: UIImage, asset: PHAsset?) {
//        Task {
//            isLoading = true
//            errorMessage = nil
//            
//            do {
//                let photo = try await photoService.addPhoto(image: image, asset: asset)
//                photos.append(photo)
//                print("✅ ViewModel: 사진 추가 성공 - ID=\(photo.id)")
//            } catch {
//                errorMessage = "사진 추가 실패: \(error.localizedDescription)"
//                print("❌ ViewModel: 사진 추가 실패 - \(error)")
//            }
//            
//            isLoading = false
//        }
//    }
//
//    /// 사진 추가 (메모와 날짜 포함)
//    func addPhoto(image: UIImage, memo: String, date: Date) {
//        Task {
//            isLoading = true
//            errorMessage = nil
//            
//            do {
//                let photo = try await photoService.addPhoto(image: image, memo: memo, date: date)
//                photos.append(photo)
//                print("✅ ViewModel: 사진 추가 성공 - ID=\(photo.id), 메모=\(memo)")
//            } catch {
//                errorMessage = "사진 추가 실패: \(error.localizedDescription)"
//                print("❌ ViewModel: 사진 추가 실패 - \(error)")
//            }
//            
//            isLoading = false
//        }
//    }
//
//    /// 서버에 사진 업로드
//    func uploadPhoto(_ photo: LocalPhoto) async {
//        isLoading = true
//        errorMessage = nil
//
//        do {
//            let babyId: Int64 = photo.babyId ?? 1
//            let uploadedPhoto = try await photoService.uploadPhoto(photo, babyId: babyId)
//            print("✅ ViewModel: 서버 업로드 성공 - ID=\(uploadedPhoto.id)")
//        } catch {
//            errorMessage = "업로드 실패: \(error.localizedDescription)"
//            print("❌ ViewModel: 업로드 실패 - \(error)")
//        }
//
//        isLoading = false
//    }
//
//    /// 서버에서 사진 가져오기
//    func fetchPhotosFromServer() async {
//        isLoading = true
//        errorMessage = nil
//
//        do {
//            let serverPhotos = try await photoService.fetchPhotosFromServer()
//            print("✅ ViewModel: 서버에서 \(serverPhotos.count)개 사진 가져오기 성공")
//            // TODO: 서버 사진 처리 (이미지 다운로드 등)
//        } catch {
//            errorMessage = "다운로드 실패: \(error.localizedDescription)"
//            print("❌ ViewModel: 다운로드 실패 - \(error)")
//        }
//
//        isLoading = false
//    }
//
//    /// 사진 삭제
//    func deletePhoto(_ photo: LocalPhoto) async {
//        // 로컬에서 삭제
//        photos.removeAll { $0.id == photo.id }
//        
//        isLoading = true
//        errorMessage = nil
//        
//        do {
//            // Service를 통해 삭제 처리
//            try await photoService.deletePhoto(photo)
//            
//            // 서버에서도 삭제 (옵션)
//            try await photoService.deletePhotoFromServer(id: photo.id)
//            
//            print("✅ ViewModel: 사진 삭제 성공 - ID=\(photo.id)")
//        } catch {
//            errorMessage = "삭제 실패: \(error.localizedDescription)"
//            print("❌ ViewModel: 삭제 실패 - \(error)")
//        }
//        
//        isLoading = false
//    }
//
//    // MARK: - Private Methods
//
//    private func setupBindings() {
//        // 위치 업데이트 구독
//        locationManager.$location
//            .sink { [weak self] location in
//                self?.currentLocation = location
//            }
//            .store(in: &cancellables)
//    }
//
//    /// 로컬 저장소에서 사진 불러오기
//    private func loadPhotos() {
//        do {
//            photos = try photoService.loadPhotos()
//            print("✅ ViewModel: \(photos.count)개 사진 로드 완료")
//        } catch {
//            errorMessage = "사진 불러오기 실패: \(error.localizedDescription)"
//            print("❌ ViewModel: 사진 불러오기 실패 - \(error)")
//        }
//    }
//}
//
//
