//
//  FullMapView.swift
//  babyMoa
//
//  Created by pherd on 11/21/25.
//

import MapKit
import SwiftUI

/// 전체 화면 지도 뷰
/// - 줌, 이동 등 자유로운 지도 조작 가능
/// - 마커 탭 시 리스트 표시
struct FullMapView: View {
    // MARK: - Properties
    @Binding var isPresented: Bool
    var journeyVM: JourneyViewModel // 데이터 소스 (@Observable 사용 시 그냥 var로 선언)
    @Binding var listContext: JourneyListContextWrapper? // 리스트 표시용
    
    // 지도 상태
    @State private var position: MapCameraPosition
    @State private var locationManager = LocationManager()
    
    // 초기 위치를 받아서 설정
    init(
        isPresented: Binding<Bool>,
        journeyVM: JourneyViewModel,
        listContext: Binding<JourneyListContextWrapper?>,
        initialPosition: MapCameraPosition
    ) {
        self._isPresented = isPresented
        self.journeyVM = journeyVM
        self._listContext = listContext
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
                // 대표 여정만 추출하여 마커로 표시 (MapCardViewModel 로직 재사용 가능하지만 간단히 여기서 처리)
                ForEach(representativeJournies) { journey in
                    Annotation("", coordinate: journey.coordinate) {
                        PhotoMarkerView(image: journey.journeyImage)
                            .onTapGesture {
                                // 마커 탭 -> 해당 날짜의 모든 여정 찾아서 리스트 표시
                                let journiesForDate = journeyVM.journies.filter {
                                    $0.date.isSameDay(as: journey.date)
                                }
                                listContext = JourneyListContextWrapper(
                                    date: journey.date,
                                    journies: journiesForDate
                                )
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
    
    /// 날짜별 대표 여정 추출 (하루에 하나만 마커 표시)
    private var representativeJournies: [Journey] {
        var uniqueDates: [String: Journey] = [:]
        for journey in journeyVM.journies {
            let dateKey = DateFormatter.yyyyMMdd.string(from: journey.date)
            if uniqueDates[dateKey] == nil {
                uniqueDates[dateKey] = journey
            }
        }
        return Array(uniqueDates.values)
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
