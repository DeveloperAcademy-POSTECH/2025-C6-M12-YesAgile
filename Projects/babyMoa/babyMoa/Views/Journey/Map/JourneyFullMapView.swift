//
//  JourneyFullMapView.swift
//  babyMoa
//
//  Created by pherd on 11/21/25.
//  Refactored on 11/22/25
//

import MapKit
import SwiftUI

/// 전체 화면 지도 뷰
/// - 줌, 이동 등 자유로운 지도 조작 가능
/// - 마커 탭 시 리스트 표시
struct JourneyFullMapView: View {
    // MARK: - Properties
    @Binding var isPresented: Bool
    let journeys: [Journey] // ViewModel 의존성 제거, 데이터만 받음
    let onMarkerTapped: (Date) -> Void // 마커 탭 액션 전달
    
    // 지도 상태
    @State private var position: MapCameraPosition
    @State private var locationManager = LocationManager()
    
    // 초기 위치를 받아서 설정
    init(
        isPresented: Binding<Bool>,
        journeys: [Journey],
        initialPosition: MapCameraPosition,
        onMarkerTapped: @escaping (Date) -> Void
    ) {
        self._isPresented = isPresented
        self.journeys = journeys
        self.onMarkerTapped = onMarkerTapped
        self._position = State(initialValue: initialPosition)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // 1. 지도
            Map(position: $position) {
                // 사용자 위치
                if let userLocation = locationManager.location {
                    Annotation("내 위치", coordinate: userLocation.coordinate) {
                        UserLocationMarker()
                    }
                }
                
                // 여정 마커들
                ForEach(dispersedJourneys) { journey in
                    Annotation("", coordinate: journey.coordinate) {
                        JourneyMapMarkerView(imageUrl: journey.imageUrl, fallbackImage: journey.journeyImage)
                            .onTapGesture {
                                onMarkerTapped(journey.date)
                            }
                    }
                }
            }
            .mapStyle(.standard)
            
            // 2. 닫기 버튼 (상단 우측)
            Button {
                isPresented = false
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding(.top, 60) // Safe Area 고려
            .padding(.trailing, 20)
            
            // 3. 나침반 / 현재위치 버튼 (하단 우측)
            VStack(spacing: 12) {
                Spacer()
                
                Button {
                    moveToCurrentLocation()
                } label: {
                    Image(systemName: "location.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                        .frame(width: 48, height: 48)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
            .padding(.bottom, 40)
            .padding(.trailing, 20)
        }
        .ignoresSafeArea() // 전체 화면 채우기
        .onAppear {
            locationManager.startUpdating()
        }
    }
    
    // MARK: - Helpers
    
    /// 겹치는 마커들을 원형으로 분산시킨 여정 목록 (Jittering)
    private var dispersedJourneys: [Journey] {
        // 1. 위치별로 그룹핑 (소수점 4자리 약 11m 단위로 근접 위치 판단)
        var grouped: [String: [Journey]] = [:]
        
        for journey in journeys {
            // 모든 여정을 보여주기 위해 날짜 필터링 제거
            let lat = String(format: "%.4f", journey.latitude)
            let lon = String(format: "%.4f", journey.longitude)
            let key = "\(lat)_\(lon)"
            grouped[key, default: []].append(journey)
        }
        
        var result: [Journey] = []
        
        // 2. 각 그룹별로 좌표 조정
        for (_, group) in grouped {
            if group.count == 1 {
                result.append(group[0])
            } else {
                // 겹치는 마커가 있으면 원형으로 배치
                // 0.0003도는 대략 30m 정도의 거리 (화면상 겹치지 않을 정도)
                let radius = 0.0003
                
                for (index, journey) in group.enumerated() {
                    var modifiedJourney = journey
                    
                    // 각도 계산 (360도를 개수로 나눔)
                    // 시작 각도를 -90도(12시 방향)부터 시작하면 더 자연스러울 수 있음
                    let angle = (2.0 * .pi / Double(group.count)) * Double(index) - (.pi / 2)
                    
                    // 위도/경도 오프셋 적용
                    modifiedJourney.latitude += radius * sin(angle) // 위도(Y축)는 sin으로 적용 (지도 좌표계 고려)
                    modifiedJourney.longitude += radius * cos(angle) // 경도(X축)는 cos으로 적용
                    
                    result.append(modifiedJourney)
                }
            }
        }
        
        return result
    }
    
    /// 현재 위치로 지도 이동
    private func moveToCurrentLocation() {
        guard let location = locationManager.location else { return }
        withAnimation {
            position = .region(
                MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )
        }
    }
}

// MARK: - Subviews

/// 내 위치 마커
struct UserLocationMarker: View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 18, height: 18)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 3)
            )
            .shadow(radius: 3)
    }
}

#Preview {
    JourneyFullMapView(
        isPresented: .constant(true),
        journeys: Journey.mockData,
        initialPosition: .automatic,
        onMarkerTapped: { _ in }
    )
}

