//
//  JourneyMainView.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//

import MapKit
import Photos
import SwiftUI
import CoreLocation

struct JourneyMainView: View {
    // MARK: - Properties
    let coordinator: BabyMoaCoordinator

    // State for Map Integration
    @State private var showMap = false
    @State private var mapCenter: CLLocationCoordinate2D =
        CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780) // Default: Seoul
    @StateObject private var locationManager = LocationManager()

    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea() // 배경을 안전영역까지 채움 (투명 느낌 제거)

            ScrollView {
                VStack(spacing: 20) {
                    // 1) 달력 카드
                    JourneyCalendarView()

                    // 2) 지도 스냅샷 카드 (탭하면 풀스크린 지도)
                    JourneySnapshotView(
                        centerCoordinate: mapCenter,
                        onTap: { showMap = true }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24) // MainTopNavigationView의 safeAreaInset 아래로 적당한 여백
            }
            .background(Color.background)
            .onAppear { locationManager.startUpdating() }
            .onDisappear { locationManager.stopUpdating() }
        }

        // ✅ 최상위 NavigationStack의 스타일을 이 화면에서도 확고히: 투명/유리화 방지
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbar(.hidden, for: .navigationBar)   // 🔧 추가: Map이 있어도 상단 라인 생기지 않음


        // 지도 전체 화면
        .fullScreenCover(isPresented: $showMap) {
            JourneyMapView(
                isPresented: $showMap,
                initialPosition: .region(
                    MKCoordinateRegion(
                        center: mapCenter,
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    )
                )
            )
            // 풀스크린 지도는 의도적으로 시스템 크롬 없이 전면 표시
            .ignoresSafeArea()
        }

        // 위치 변경 시 스냅샷 중심 업데이트
        .onChange(of: locationManager.location) { _, newLocation in
            if let newLocation {
                mapCenter = newLocation.coordinate
            }
        }
    }
}

#Preview {
    JourneyMainView(coordinator: BabyMoaCoordinator())
}
