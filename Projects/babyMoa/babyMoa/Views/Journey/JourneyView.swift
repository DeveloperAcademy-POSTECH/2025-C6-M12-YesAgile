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
    // MARK: - View가 화면 전환 책임을 가짐 (ViewModel은 순수 비즈니스 로직만) 맨아래 위치정보 alert 주석 및 최신 리스트 업데이트 위해서 아래에!!
    let coordinator: BabyMoaCoordinator

    @State private var journeyVM: JourneyViewModel
    @State private var calendarCardVM: CalendarCardViewModel
    @State private var mapCardVM: MapCardViewModel
    @State private var locationManager = LocationManager()  // 현재 위치 관리
    @State private var mapPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 36.5,
                longitude: 127.5
            ),
            span: MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 4.0)
        )
    )

    // MARK: - fullScreenCover용 State
    @State private var showAddView = false
    @State private var selectedDateForAdd: Date = Date()
    
    // [2024-11-20] 수정: Context 부활 시트 트리거
    @State private var listContext: JourneyListContext? = nil

    // MARK: - 사진 라이브러리 권한 관련 State
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
        _mapCardVM = State(initialValue: MapCardViewModel())  // 순수 계산용이라 새로 생성만
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    CalendarCard(
                    data: CalendarCardData(
                        currentMonth: calendarCardVM.currentMonth,
                        monthDates: calendarCardVM.monthDates,
                        selectedDate: calendarCardVM.selectedDate,
                        // [2024-11-20] journeyVM.journies 직접 주입: 데이터 변경 시 캘린더 즉시 갱신 보장 (Nested Observable 이슈 방지)
                        journies: journeyVM.journies
                    ),
                    actions: CalendarCardActions(
                        onPreviousMonth: {
                            calendarCardVM.previousMonthTapped()

                            Task {
                                await journeyVM.fetchJournies(
                                    for: calendarCardVM.currentMonth
                                )
                            }
                        },
                        onNextMonth: {
                            calendarCardVM.nextMonthTapped()

                            Task {
                                await journeyVM.fetchJournies(
                                    for: calendarCardVM.currentMonth
                                )
                            }
                        },
                        // 캘린더 날짜 탭 시 화면 전환 로직
                        onDateTap: { date in
                            // 1. 탭한 날짜 선택 & 해당 날짜의 여정 가져오기
                            let journiesForDate = calendarCardVM.dateTapped(date)

                            // 2. 여정 존재 여부에 따라 화면 분기
                            if journiesForDate.isEmpty {
                                // 여정 없음: 여정 추가 화면으로 이동
                                selectedDateForAdd = date
                                showAddView = true
                            } else {
                                // 여정 있음: Context 생성하여 리스트 시트 오픈
                                listContext = JourneyListContext(
                                    date: date,
                                    journies: journiesForDate
                                )
                            }
                        },
                        isInCurrentMonth: { date in
                            calendarCardVM.isInCurrentMonth(date)
                        },
                        isSelected: { date in
                            let result = calendarCardVM.isSelected(date)
                            return result  // true 또는 false
                        }
                        //          ↑ 여기서 함수를 전달!
                        //

                    )
                    )
                    .padding(.horizontal, 20)
                    MapCard(
                    data: MapCardData(
                        position: $mapPosition,
                        // 위치 있는 대표 여정을 마커로 전달 (Journey 모델 직접 사용)
                        annotations: mapCardVM.representativeJournies(from: journeyVM.journies),
                        userLocation: locationManager.location
                    ),
                    actions: MapCardActions(
                        onMarkerTap: { date in
                            // 마커 탭 시
                            let allJourniesForDate = mapCardVM.journies(
                                for: date,
                                from: journeyVM.journies
                            )
                            listContext = JourneyListContext(
                                date: date,
                                journies: allJourniesForDate
                            )
                        },
                        onCompassTap: {
                            // 나침반 버튼 탭 시: 현재 위치로 이동 (없으면 첫 번째 여정 위치로 fallback)
                            if let currentLocation = locationManager.location {
                                withAnimation {
                                    mapPosition = .region(
                                        MKCoordinateRegion(
                                            center: currentLocation.coordinate,
                                            span: MKCoordinateSpan(
                                                latitudeDelta: 0.1,
                                                longitudeDelta: 0.1
                                            )
                                        )
                                    )
                                }
                            } else {
                                // 현재 위치 없으면 첫 번째 여정 위치로 이동
                                if let firstJourney =
                                    mapCardVM
                                    .representativeJournies(
                                        from: journeyVM.journies
                                    )
                                    .first
                                {
                                    withAnimation {
                                        mapPosition = .region(
                                            MKCoordinateRegion(
                                                center: firstJourney.coordinate,
                                                span: MKCoordinateSpan(
                                                    latitudeDelta: 0.1,
                                                    longitudeDelta: 0.1
                                                )
                                            )
                                        )
                                    }
                                }
                            }
                        }
                    )
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 24)
            }
        }
        .onAppear {
            Task {
                // MARK: - 사진 라이브러리 권한 체크 (여정 탭 진입 시) -> 처음 시작시에 Todo : 여기 위치가 맞는지..
                let photoStatus =
                    PhotoLibraryPermissionHelper.checkAuthorizationStatus()

                switch photoStatus {
                case .notDetermined:
                    // 여정 탭 첫 진입: 권한 요청
                    let newStatus =
                        await PhotoLibraryPermissionHelper.requestAuthorization()

                    if newStatus == .limited {
                        showPhotoAccessAlert = true
                    }

                case .limited:
                    // Limited Access: 안내 표시
                    break

                case .authorized:
                    break

                case .denied, .restricted:
                    break

                @unknown default:
                    break
                }

                // MARK: - babyId 동기화 (ViewModel에 위임)
                // MainTabViewModel이 SelectedBabyState에 아기 정보를 설정하면,
                // JourneyViewModel에서 SelectedBaby.babyId에 동기화 (API 호출 시 필요)
                journeyVM.syncBabyId()

                // 현재 월의 여정 데이터 서버에서 가져오기
                await journeyVM.fetchJournies(for: calendarCardVM.currentMonth)

                // 위치 업데이트 시작 (데이터 로드 후에 시작하여 hang 방지)
                locationManager.startUpdating()
                
                // 지도 초기 위치 우선순위:
                // 1. 현재 위치 (locationManager)
                // 2. 첫 번째 여정 위치
                // 3. 대한민국 중심 (서울)
                if let currentLocation = locationManager.location {
                    mapPosition = .region(
                        MKCoordinateRegion(
                            center: currentLocation.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        )
                    )
                } else if let firstJourney = mapCardVM.representativeJournies(from: journeyVM.journies).first {
                    mapPosition = .region(
                        MKCoordinateRegion(
                            center: firstJourney.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        )
                    )
                } else {
                    // 기본값: 한반도 보이게
                    mapPosition = .region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 37.5, longitude: 127.5),
                            span: MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 4.0)
                        )
                    )
                }
            }
        }
        // MARK: - fullScreenCover
        .fullScreenCover(isPresented: $showAddView) {
            JourneyAddView(
                selectedDate: selectedDateForAdd,
                photoAccessStatus:
                    PhotoLibraryPermissionHelper.checkAuthorizationStatus(),
                // - JourneyAddView는 추가 모드로 동작
                // - onSave에서 journeyVM.addJourney 호출
                // - 편집 모드는 JourneyListView에서 처리 (journeyVM.updateJourney)
                onSave: { image, memo, latitude, longitude in
                    Task {
                        // 서버에 여정 추가 API 호출 (JourneyViewModel)
                        let success = await journeyVM.addJourney(
                            image: image,
                            memo: memo,
                            date: selectedDateForAdd,
                            latitude: latitude,
                            longitude: longitude
                        )

                        if !success {
                            print("❌ 여정 저장 실패")
                        }
                        // 성공 시: journeyVM.journies 배열이 업데이트되어
                        // CalendarCard와 MapCard가 자동으로 갱신
                    }
                },
                onDismiss: {
                    showAddView = false
                }
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
                onDismiss: {
                    listContext = nil
                }
            )
        }
        // fullScreenCover(item: $gridContext) 제거 (JourneyGridView 사용 중단)
        // MARK: - Limited Access 안내 Alert
        .alert("📍 위치 기반 여정 기록", isPresented: $showPhotoAccessAlert) {
            Button("설정으로 이동") {
                PhotoLibraryPermissionHelper.openSettings()
            }
            Button("나중에", role: .cancel) {}
        } message: {
            Text(
                "사진의 위치 정보를 사용하여 지도에 여정을 표시합니다.\n\n'설정 → BabyMoa → 사진'에서 '모든 사진'을 선택해주세요."
            )
        }
    }
}

// MARK: - Identifiable Context

/// fullScreenCover 시트 오픈을 위한 포장지(Wrapper)
/// - 시트를 "유지"하는 역할. 내부 데이터가 갱신되어도 이 객체(id)는 변하지 않아야 함.
private struct JourneyListContext: Identifiable {
    let id = UUID()
    let date: Date
    let journies: [Journey]
}

#Preview {
    JourneyView(coordinator: BabyMoaCoordinator())
}
