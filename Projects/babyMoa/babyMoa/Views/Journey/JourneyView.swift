//
//  JourneyView.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//
import MapKit
import Photos  // PhotoLibraryPermissionHelper에서 PHAuthorizationStatus 사용
import SwiftUI

struct JourneyView: View {
    // MARK: - Properties
    let coordinator: BabyMoaCoordinator

    @State private var journeyVM: JourneyViewModel
    @State private var calendarCardVM: CalendarCardViewModel
    
    // Map 관련 상태 단순화 (좌표만 관리)
    @State private var locationManager = LocationManager()
    @State private var mapCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: 37.5665,
        longitude: 126.9780
    ) // 서울 시청 (초기값)

    // MARK: - 화면 전환 State
    @State private var showAddView = false
    @State private var selectedDateForAdd: Date = Date()
    @State private var showFullMap = false
    @State private var listContext: JourneyListContextWrapper? = nil
    @State private var showPhotoAccessAlert = false

    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        let journeyViewModel = JourneyViewModel()
        _journeyVM = State(initialValue: journeyViewModel)
        _calendarCardVM = State(
            initialValue: CalendarCardViewModel(
                journeyViewModel: journeyViewModel
            )
        )
        // MapCardViewModel 제거 (뷰모델 역할 축소)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 1. 캘린더 카드
                CalendarCard(
                    data: CalendarCardData(
                        currentMonth: calendarCardVM.currentMonth,
                        monthDates: calendarCardVM.monthDates,
                        selectedDate: calendarCardVM.selectedDate,
                        journies: journeyVM.journies
                    ),
                    actions: CalendarCardActions(
                        onPreviousMonth: {
                            calendarCardVM.previousMonthTapped()
                            Task { await journeyVM.fetchJournies(for: calendarCardVM.currentMonth) }
                        },
                        onNextMonth: {
                            calendarCardVM.nextMonthTapped()
                            Task { await journeyVM.fetchJournies(for: calendarCardVM.currentMonth) }
                        },
                        onDateTap: { date in
                            let journiesForDate = calendarCardVM.dateTapped(date)
                            if journiesForDate.isEmpty {
                                selectedDateForAdd = date
                                showAddView = true
                            } else {
                                listContext = JourneyListContextWrapper(date: date, journies: journiesForDate)
                            }
                        },
                        isInCurrentMonth: { calendarCardVM.isInCurrentMonth($0) },
                        isSelected: { calendarCardVM.isSelected($0) }
                    )
                )
                
                // 2. 지도 스냅샷 카드 (심플 버전)
                MapCard(
                    coordinate: mapCenter,
                    onTap: { showFullMap = true }
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(Color.background)
        .onAppear {
            Task {
                await checkPhotoPermission()
                journeyVM.syncBabyId()
                await journeyVM.fetchJournies(for: calendarCardVM.currentMonth)
                locationManager.startUpdating()
                
                // 초기 지도 위치 설정
                updateMapCenter()
            }
        }
        // MARK: - Full Screen Covers
        .fullScreenCover(isPresented: $showAddView) {
            JourneyAddView(
                selectedDate: selectedDateForAdd,
                photoAccessStatus: PhotoLibraryPermissionHelper.checkAuthorizationStatus(),
                onSave: { image, memo, lat, lon in
                    Task {
                        _ = await journeyVM.addJourney(
                            image: image, memo: memo, date: selectedDateForAdd,
                            latitude: lat, longitude: lon
                        )
                    }
                },
                onDismiss: { showAddView = false }
            )
        }
        .fullScreenCover(item: $listContext) { context in
            JourneyListView(
                viewModel: JourneyListViewModel(
                    date: context.date,
                    journies: context.journies,
                    parentVM: journeyVM
                ),
                onAddJourney: {
                    listContext = nil
                    selectedDateForAdd = context.date
                    showAddView = true
                },
                onDismiss: { listContext = nil }
            )
        }
        .fullScreenCover(isPresented: $showFullMap) {
            // FullMapView에 초기 위치 전달
            FullMapView(
                isPresented: $showFullMap,
                journeyVM: journeyVM,
                listContext: $listContext,
                initialPosition: .region(MKCoordinateRegion(
                    center: mapCenter,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                ))
            )
        }
        .alert("📍 위치 기반 여정 기록", isPresented: $showPhotoAccessAlert) {
            Button("설정으로 이동") { PhotoLibraryPermissionHelper.openSettings() }
            Button("나중에", role: .cancel) {}
        } message: {
            Text("사진의 위치 정보를 사용하여 지도에 여정을 표시합니다.\n\n'설정 → BabyMoa → 사진'에서 '모든 사진'을 선택해주세요.")
        }
    }
    
    // MARK: - Private Helpers
    
    private func checkPhotoPermission() async {
        let status = PhotoLibraryPermissionHelper.checkAuthorizationStatus()
        if status == .notDetermined {
            let newStatus = await PhotoLibraryPermissionHelper.requestAuthorization()
            if newStatus == .limited { showPhotoAccessAlert = true }
        }
    }
    
    private func updateMapCenter() {
        // 1. 내 위치
        if let location = locationManager.location {
            mapCenter = location.coordinate
            return
        }
        // 2. 첫 번째 여정 위치
        if let first = journeyVM.journies.first(where: { $0.latitude != 0 }) {
            mapCenter = first.coordinate
            return
        }
        // 3. 기본값 (서울) - 이미 init에서 설정됨
    }
}

#Preview {
    JourneyView(coordinator: BabyMoaCoordinator())
}
