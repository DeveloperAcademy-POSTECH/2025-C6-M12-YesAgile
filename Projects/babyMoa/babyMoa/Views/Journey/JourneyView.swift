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
    // MARK: - View가 화면 전환 책임을 가짐 (ViewModel은 순수 비즈니스 로직만)
    let coordinator: BabyMoaCoordinator

    @State private var journeyVM: JourneyViewModel
    @State private var calendarCardVM: CalendarCardViewModel
    @State private var mapCardVM: MapCardViewModel
    @State private var mapPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.5665,
                longitude: 126.9780
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )

    // MARK: - fullScreenCover용 State
    @State private var showAddView = false
    @State private var selectedDateForAdd: Date = Date()
    @State private var showListView = false
    @State private var selectedDateForList: Date = Date()
    @State private var journiesForSelectedDate: [Journey] = []
    @State private var gridContext: JourneyGridContext? = nil

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
        _mapCardVM = State(initialValue: MapCardViewModel()) // 순수 계산용이라 새로 생성만
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 달력 카드 직접 뷰모델을 통해 값을 주입
                CalendarCard(
                    data: CalendarCardData(
                        currentMonth: calendarCardVM.currentMonth,
                        monthDates: calendarCardVM.monthDates,
                        selectedDate: calendarCardVM.selectedDate,
                        journies: calendarCardVM.journies
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
                            let journiesForDate = calendarCardVM.dateTapped(
                                date
                            )

                            // 2. 여정 존재 여부에 따라 화면 분기
                            if journiesForDate.isEmpty {
                                // 여정 없음: 여정 추가 화면으로 이동
                                selectedDateForAdd = date
                                showAddView = true
                            } else {
                                // 여정 있음: 여정 상세 화면으로 이동
                                selectedDateForList = date
                                journiesForSelectedDate = journiesForDate
                                showListView = true
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

                // 지도 카드
                MapCard(
                    data: MapCardData(
                        position: $mapPosition,
                        // ✅ journeyVM.journies를 직접 전달 (데이터 중복 제거)
                        annotations:
                            mapCardVM
                            .representativeJournies(from: journeyVM.journies)
                            .map { journey in
                                // ✅ 같은 날짜의 위치 있는 여정 개수 계산
                                let dateJournies = journeyVM.journies.filter {
                                    eachJourney in
                                    eachJourney.date.isSameDay(as: journey.date)
                                        && eachJourney.hasValidLocation
                                }
                                return JourneyAnnotation(
                                    from: journey,
                                    count: dateJournies.count
                                )
                            }
                    ),
                    actions: MapCardActions(
                        onMarkerTap: { date in
                            // 1. 탭한 마커의 날짜에 해당하는 모든 여정 가져오기
                            let allJourniesForDate = mapCardVM.journies(
                                for: date,
                                from: journeyVM.journies
                            )

                            // 2. 위치 정보가 있는 여정만 필터링 (lat/lng가 유효한 것만)
                            let validJourniesForDate = allJourniesForDate.filter
                            { journey in
                                journey.hasValidLocation
                            }

                            // 3. 여정 개수에 따라 화면 분기
                            if validJourniesForDate.count > 1 {
                                // 2개 이상: 그리드 화면으로 이동하여 여러 사진 보여주기
                                selectedDateForList = date

                                // Identifiable Context로 최신 데이터 보장 (SwiftUI 캐싱 문제 해결)
                                gridContext = JourneyGridContext(
                                    date: date,
                                    journies: validJourniesForDate
                                )

                            } else if validJourniesForDate.count == 1 {
                                // 1개: 상세 화면으로 바로 이동
                                selectedDateForList = date
                                journiesForSelectedDate = validJourniesForDate
                                showListView = true

                            } else {
                                // 0개: 마커가 있는데 유효한 여정이 없는 경우 (비정상 상태)
                                print("⚠️ 유효한 여정 없음")
                            }
                        },
                        onCompassTap: {
                            // 나침반 버튼 탭 시: 지도를 첫 번째 여정 위치로 이동
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
                    )
                )
                .padding(.horizontal, 20)

                Spacer().frame(height: 30)
            }
            .padding(.top, 20)
        }
        .onAppear {
            Task {
                // MARK: - 사진 라이브러리 권한 체크 (여정 탭 진입 시)
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

                // MARK: - babyId 동기화
                // MainTabViewModel이 SelectedBabyState에 아기 정보를 설정하면,
                // 여기서 SelectedBaby.babyId에 동기화 (API 호출 시 필요)
                // MainTabViewModel (아기 선택 시 자동 설정) 로 이야기해보거나
                //JourneyViewModel (필요 시 직접 조회)로 이동 예정 Tod
                if let baby = SelectedBabyState.shared.baby {
                    SelectedBaby.babyId = baby.babyId
                } else {
                    print("⚠️ SelectedBabyState.shared.baby가 nil")
                }

                // 현재 월의 여정 데이터 서버에서 가져오기
                await journeyVM.fetchJournies(for: calendarCardVM.currentMonth)

                // 지도 초기 위치: 첫 번째 여정의 위치로 설정
                if let firstJourney =
                    mapCardVM
                    .representativeJournies(from: journeyVM.journies)
                    .first
                {
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
        // MARK: - fullScreenCover (GrowthView 패턴)
        .fullScreenCover(isPresented: $showAddView) {
            JourneyAddView(
                selectedDate: selectedDateForAdd,
                photoAccessStatus:
                    PhotoLibraryPermissionHelper.checkAuthorizationStatus(),
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
                        // CalendarCard와 MapCard가 자동으로 갱신됨 (@Observable)
                    }
                },
                onDismiss: {
                    showAddView = false
                }
            )
        }
        .fullScreenCover(isPresented: $showListView) {
            JourneyListView(
                selectedDate: selectedDateForList,
                journies: journiesForSelectedDate,
                onAddJourney: {
                    showListView = false
                    selectedDateForAdd = selectedDateForList
                    showAddView = true
                },
                onDeleteJourney: { journey in
                    Task {
                        // 서버에 여정 삭제 API 호출 (JourneyViewModel)
                        let success = await journeyVM.removeJourney(journey)

                        if success {
                            // 삭제 성공: 현재 날짜의 여정 목록 다시 필터링하여 화면 갱신
                            journiesForSelectedDate = journeyVM.journies.filter
                            { journey in
                                journey.date.isSameDay(as: selectedDateForList)
                            }
                        } else {
                            print("❌ 여정 삭제 실패: journeyId=\(journey.journeyId)")
                            // TODO: 사용자에게 실패 알림 (Alert 등)
                        }
                    }
                },
                onDismiss: {
                    showListView = false
                }
            )
        }
        .fullScreenCover(item: $gridContext) { context in
            // MARK: - Identifiable Context 기반 fullScreenCover
            // 문제: Bool 기반 fullScreenCover는 초기 렌더 시점을 캐시하여 첫 클릭에 빈 배열 전달
            // 해결: 보여줄 여정을 포함하는 Identifiable Context를 바인딩 → 매번 최신 데이터로 생성
            JourneyGridView(
                selectedDate: context.date,
                journies: context.journies,
                onJourneyTap: { journey in
                    gridContext = nil  // 시트 닫기
                    journiesForSelectedDate = [journey]
                    showListView = true
                },
                onDismiss: {
                    gridContext = nil  // Cancel 등 기타 닫기 경로
                }
            )
        }
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

// MARK: - Identifiable Context (fullScreenCover 전용)
/// Bool state 대신 Identifiable 컨텍스트를 사용하여
/// fullScreenCover가 항상 최신 데이터를 기반으로 표시되도록 한다.
private struct JourneyGridContext: Identifiable {
    let id = UUID()
    let date: Date
    let journies: [Journey]
}
#Preview {
    JourneyView(coordinator: BabyMoaCoordinator())
}
