//
//  JourneyViewModel.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//
import Foundation
import SwiftUI
import CoreLocation
import MapKit
import Photos
//
//@MainActor
//@Observable class JourneyViewModel {
//    // MARK: - Child ViewModels
//    var calendarViewModel: JourneyCalendarViewModel
//    var mapViewModel: JourneyMapViewModel
//    var addViewModel: JourneyAddViewModel?
//
//    // MARK: - Core Data
//    var journies: [Journey] = [] {
//        didSet {
//            calendarViewModel.journies = self.journies
//            mapViewModel.journies = self.journies
//        }
//    }
//
//    // MARK: - Navigation State
//    var listContext: JourneyListContextWrapper? = nil
//    var showPhotoAccessAlert = false
//    
//    // MARK: - Map State
//    private var locationManager = LocationManager()
//    var mapCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780) {
//        didSet {
//            let newPosition = MapCameraPosition.region(MKCoordinateRegion(center: mapCenter, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
//            mapViewModel.position = newPosition
//        }
//    }
//
//    init() {
//        let initialPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
//        
//        self.calendarViewModel = JourneyCalendarViewModel(journies: [], onMonthChange: { _ in }, onDateTap: { _ in })
//        self.mapViewModel = JourneyMapViewModel(journies: [], initialPosition: initialPosition)
//        
//        self.calendarViewModel = JourneyCalendarViewModel(
//            journies: self.journies,
//            onMonthChange: { [weak self] newMonth in self?.handleMonthChange(newMonth: newMonth) },
//            onDateTap: { [weak self] date in self?.handleDateTap(date: date) }
//        )
//        self.mapViewModel = JourneyMapViewModel(journies: self.journies, initialPosition: initialPosition)
//    }
//
//    // MARK: - Public Actions
//    func onAppear() {
//        // Task {
//            // await checkPhotoPermission() // Commented out due to API/data interaction
//            // syncBabyId() // Commented out due to API/data interaction
//            // await fetchJournies(for: Date()) // Commented out due to API/data interaction
//            // locationManager.startUpdating() // Keep this, it's UI/local state
//            updateMapCenter() // Keep this, it's UI/local state
//        // }
//        // Provide mock data for development
//        self.journies = Journey.mockData
//    }
//    
//    // MARK: - Callback Handlers
//    private func handleMonthChange(newMonth: Date) {
//        Task { await fetchJournies(for: newMonth) }
//    }
//    
//    private func handleDateTap(date: Date) {
//        let journiesForDate = self.journies.filter { $0.date.isSameDay(as: date) }
//        if journiesForDate.isEmpty {
//            self.addViewModel = JourneyAddViewModel(onSave: { [weak self] image, memo, lat, lon in
//                guard let self = self else { return }
//                Task {
//                    _ = await self.addJourney(image: image, memo: memo, date: date, latitude: lat, longitude: lon)
//                }
//            })
//        } else {
//            listContext = JourneyListContextWrapper(date: date, journies: journiesForDate)
//        }
//    }
//
//    // MARK: - Private Helpers
//    private func checkPhotoPermission() async {
//        let status = PhotoLibraryPermissionHelper.checkAuthorizationStatus()
//        if status == .notDetermined {
//            let newStatus = await PhotoLibraryPermissionHelper.requestAuthorization()
//            if newStatus == .limited { showPhotoAccessAlert = true }
//        }
//    }
//    
//    private func updateMapCenter() {
//        if let location = locationManager.location { mapCenter = location.coordinate; return }
//        if let first = journies.first(where: { $0.latitude != 0 }) { mapCenter = first.coordinate; return }
//    }
//
//    // MARK: - Data Management
//    func syncBabyId() {
//        if let baby = SelectedBabyState.shared.baby { SelectedBaby.babyId = baby.babyId }
//        else { print("⚠️ SelectedBabyState.shared.baby가 nil") }
//    }
//
//    func addJourney(image: UIImage, memo: String, date: Date, latitude: Double, longitude: Double) async -> Bool {
//        guard let babyId = SelectedBaby.babyId else { print("⚠️ babyId 없음"); return false }
//        let resizedImage = ImageManager.shared.resizeImage(image, maxSize: 1024)
//        guard let base64Image = ImageManager.shared.encodeToBase64(resizedImage, compressionQuality: 0.7) else {
//            print("❌ 이미지 Base64 변환 실패"); return false
//        }
//        let result = await BabyMoaService.shared.postAddJourney(babyId: babyId, journeyImage: base64Image, latitude: latitude, longitude: longitude, date: DateFormatter.yyyyDashMMDashdd.string(from: date), memo: memo)
//        switch result {
//        case .success(let response):
//            if let data = response.data {
//                let newJourney = Journey(journeyId: data.journeyId, journeyImage: resizedImage, latitude: latitude, longitude: longitude, date: date, memo: memo)
//                journies.append(newJourney)
//                journies.sort { $0.date > $1.date }
//                return true
//            }
//            print("⚠️ 서버 응답 데이터 없음"); return false
//        case .failure(let error):
//            print("❌ 서버 저장 실패: \(error)"); return false
//        }
//    }
//
//    func updateJourney(journey: Journey, image: UIImage, memo: String, latitude: Double, longitude: Double) async -> Bool {
//        guard let babyId = SelectedBaby.babyId else { print("⚠️ babyId 없음"); return false }
//        let resizedImage = ImageManager.shared.resizeImage(image, maxSize: 1024)
//        guard let base64Image = ImageManager.shared.encodeToBase64(resizedImage, compressionQuality: 0.7) else {
//            print("❌ 이미지 Base64 변환 실패"); return false
//        }
//        let result = await BabyMoaService.shared.patchUpdateJourney(babyId: babyId, journeyId: journey.journeyId, journeyImage: base64Image, latitude: latitude, longitude: longitude, date: DateFormatter.yyyyDashMMDashdd.string(from: journey.date), memo: memo)
//        switch result {
//        case .success:
//            if let index = journies.firstIndex(where: { $0.journeyId == journey.journeyId }) {
//                journies[index] = Journey(journeyId: journey.journeyId, journeyImage: resizedImage, latitude: latitude, longitude: longitude, date: journey.date, memo: memo)
//            }
//            return true
//        case .failure(let error):
//            print("❌ 여정 수정 실패: \(error)"); return false
//        }
//    }
//
//    func removeJourney(_ journey: Journey) async -> Bool {
//        guard let babyId = SelectedBaby.babyId else { print("⚠️ babyId 없음"); return false }
//        let result = await BabyMoaService.shared.deleteJourney(babyId: babyId, journeyId: journey.journeyId)
//        switch result {
//        case .success:
//            journies.removeAll { $0 == journey }
//            return true
//        case .failure(let error):
//            print("❌ 서버 삭제 실패: \(error)"); return false
//        }
//    }
//
//    func fetchJournies(for date: Date) async {
//        guard let babyId = SelectedBaby.babyId else { print("⚠️ babyId 없음"); journies = []; return }
//        let year = Calendar.current.component(.year, from: date)
//        let month = Calendar.current.component(.month, from: date)
//        let result = await BabyMoaService.shared.getGetJourniesAtMonth(babyId: babyId, year: year, month: month)
//        switch result {
//        case .success(let response):
//            guard let models = response.data else { print("⚠️ response.data가 nil"); journies = []; return }
//            var converted: [Journey] = []
//            for model in models {
//                let journey = await model.toDomain()
//                converted.append(journey)
//            }
//            journies = converted
//        case .failure(let error):
//            print("❌ 여정 조회 실패: \(error)"); journies = []
//        }
//    }
//}
