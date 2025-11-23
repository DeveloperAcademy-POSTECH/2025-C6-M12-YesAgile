//
//  JourneyMainView.swift
//  babyMoa
//
//  Created by pherd on 11/22/25.
//

import SwiftUI
import MapKit

// Date Identifiable 확장을 피하기 위한 래퍼 클래스
// (전역 네임스페이스 오염 방지 + 참조 타입으로 안전성 강화)
fileprivate class DateWrapper: Identifiable {
    let date: Date
    var id: String { 
        // timeIntervalSince1970 사용 (고유성 보장)
        "\(date.timeIntervalSince1970)"
    }
    
    init(date: Date) {
        self.date = date
    }
    
    deinit {
    }
}

struct JourneyMainView: View {
    @State private var viewModel: JourneyMainViewModel
    @State private var calendarViewModel = JourneyCalendarViewModel()
    @State private var locationManager = LocationManager()  // 사용자 위치 추적
    
    @State private var isFullMapPresented = false
    @State private var isAddViewPresented = false
    @State private var isLocationPermissionAlertPresented = false // 위치 권한 알림 상태
    
    // 리스트 표시용 날짜 (DateWrapper 사용)
    @State private var selectedListDateWrapper: DateWrapper?
    
    init(coordinator: BabyMoaCoordinator) {
        _viewModel = State(initialValue: JourneyMainViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    // 1. 캘린더 섹션
                    // JourneyCalendarView는 자체적으로 .padding(20)과 shadow를 가지고 있음
                    // 외부에서 추가 패딩만 제공 (이중 패딩 방지)
                    JourneyCalendarView(
                        viewModel: calendarViewModel,
                        journeys: viewModel.journeys,
                        onDateSelected: { date in
                            calendarViewModel.selectDate(date)
                            let hasJourney = viewModel.journeys.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
                            
                            if hasJourney {
                                selectedListDateWrapper = DateWrapper(date: date)
                            } else {
                                isAddViewPresented = true
                            }
                        }
                    )
                    .frame(maxWidth: .infinity)  // TabView 전환 시 레이아웃 안정성 확보
                    .padding(.horizontal, 20)  // shadow 공간 확보용 좌우 여백
                    .padding(.bottom, 24)
                    .offset(y: -10) // [수정] 전체를 위로 더 끌어올림
                    
                    
                    // 2. 지도 섹션 (스냅샷)
                    VStack(alignment: .leading, spacing: 12) {
                        JourneyMapView(
                            userLocation: locationManager.location?.coordinate,
                            journeys: viewModel.journeys,
                            onTap: { 
                                // 지도 탭 시 권한 확인
                                checkLocationPermission()
                            }
                        )
                    }
                    .frame(maxWidth: .infinity)  // TabView 전환 시 레이아웃 안정성 확보
                    .padding(.horizontal, 20)  // 지도 좌우 여백
                    .padding(.bottom, 24)
                    .offset(y: -10) // [수정] 지도도 같이 위로 끌어올림
                    
                    Spacer(minLength: 100)
                }
                .frame(maxWidth: .infinity)  // ScrollView 내부 VStack 전체 너비 고정
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.fetchJourneys()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)  // 최상위 VStack이 TabView 공간 전체 사용
        .background(Color.background)
        // MARK: - Sheets & FullScreenCovers
        
        .fullScreenCover(isPresented: $isFullMapPresented) {
            JourneyFullMapView(
                isPresented: $isFullMapPresented,
                journeys: viewModel.journeys,
                initialPosition: {
                    if let userLocation = locationManager.location {
                        return .region(MKCoordinateRegion(
                            center: userLocation.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        ))
                    } else {
                        return .automatic
                    }
                }(),
                onMarkerTapped: { date in
                    isFullMapPresented = false
                    Task {
                        try? await Task.sleep(for: .milliseconds(100))
                        selectedListDateWrapper = DateWrapper(date: date)
                    }
                }
            )
        }
        
        .fullScreenCover(isPresented: $isAddViewPresented) {
            JourneyAddView(
                selectedDate: calendarViewModel.selectedDate,
                onSave: { image, memo, lat, lon in
                    Task {
                        _ = await viewModel.addJourney(
                            image: image,
                            memo: memo,
                            date: calendarViewModel.selectedDate,
                            latitude: lat,
                            longitude: lon
                        )
                    }
                },
                onDismiss: { isAddViewPresented = false }
            )
        }
        
        .fullScreenCover(item: $selectedListDateWrapper) { wrapper in
            // ViewBuilder 오류 해결을 위한 별도 함수 호출
            makeJourneyListView(for: wrapper.date, wrapperId: wrapper.id)
        }
        
        // iOS 17 대응 onChange
        .onChange(of: calendarViewModel.currentMonth) { _, newDate in
            viewModel.updateDate(newDate)
        }
        .onAppear {
            // 사용자 위치 추적 시작 (최초 권한 요청)
            locationManager.startUpdating()
            
            // 진입 시 권한 체크 (이미 거부된 경우를 위해 별도 알림은 띄우지 않고 상태만 갱신하거나, 필요하다면 여기서도 알림 가능)
            // 여기서는 '지도 탭 시'에만 알림을 띄우기로 결정했으므로 startUpdating만 호출
        }
        // 위치 권한 거부 시 알림
        .alert("위치 권한 필요", isPresented: $isLocationPermissionAlertPresented) {
            Button("설정으로 이동", role: .none) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("현재 위치를 지도에 표시하려면 위치 권한이 필요합니다. 설정에서 권한을 허용해주세요.")
        }
    }
    
    // MARK: - Helper Methods
    
    private func checkLocationPermission() {
        // LocationManager에 새로 추가된 authorizationStatus 접근자를 사용
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // 권한이 있으면 전체 지도 표시
            isFullMapPresented = true
        case .denied, .restricted:
            // 거부되었으면 설정 이동 알림 표시
            isLocationPermissionAlertPresented = true
        case .notDetermined:
            // 결정되지 않았으면 권한 요청
            locationManager.requestAuthorization()
        @unknown default:
            break
        }
    }
    
    // MARK: - View Builder Methods
    
    @ViewBuilder
    private func makeJourneyListView(for date: Date, wrapperId: String) -> some View {
        let dayJourneys = viewModel.journeys.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        
        // 생성자 주입으로 변경 (onAppear 제거)
        let listVM = JourneyListViewModel(
            date: date,
            journeys: dayJourneys,
            onDelete: { [weak viewModel] journey in
                guard let viewModel = viewModel else { return false }
                return await viewModel.deleteJourney(journey)
            },
            onUpdate: { [weak viewModel] journey, img, memo, lat, lon in
                guard let viewModel = viewModel else { return false }
                return await viewModel.updateJourney(journey: journey, image: img, memo: memo, latitude: lat, longitude: lon)
            }
        )
        
        JourneyListView(
            viewModel: listVM,
            onAddJourney: {
                selectedListDateWrapper = nil
                Task {
                    try? await Task.sleep(for: .milliseconds(500))
                    isAddViewPresented = true
                }
            },
            onDismiss: { selectedListDateWrapper = nil }
        )
    }
}
