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
    @State private var mapCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780) // Default to Seoul
    @StateObject private var locationManager = LocationManager()

    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
    }

    var body: some View {
        ZStack {
            Color.background
            
            ScrollView {
                VStack(spacing: 20) {
                    // 1. 달력 화면 구현
                    JourneyCalendarView()
                    
                    // 2. 지도 스냅샷 구현
                    JourneySnapshotView(
                        centerCoordinate: mapCenter,
                        onTap: { showMap = true }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .background(Color.background)
            .onAppear {
                locationManager.startUpdating()
            }
            .onDisappear {
                locationManager.stopUpdating()
            }
        }
        .fullScreenCover(isPresented: $showMap) {
            JourneyMapView(
                isPresented: $showMap,
                initialPosition: .region(MKCoordinateRegion(
                    center: mapCenter,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                ))
            )
        }
        .onChange(of: locationManager.location) { oldLocation, newLocation in
            if let newLocation = newLocation {
                mapCenter = newLocation.coordinate
            }
        }
    }
}

#Preview {
    JourneyMainView(coordinator: BabyMoaCoordinator())
}
