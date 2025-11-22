//
//  JourneyMapViewModel.swift
//  babyMoa
//
//  Created by Baba on 11/22/25.
//

import Foundation
import MapKit
import SwiftUI
import CoreLocation

@MainActor
@Observable
class JourneyMapViewModel {
    // MARK: - Properties
    var position: MapCameraPosition
    
    private var locationManager = LocationManager()
    
    // Simple mock data for annotations (pure map, no business logic)
    var mockAnnotations: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), // Seoul
        CLLocationCoordinate2D(latitude: 37.5600, longitude: 126.9800) // Near Seoul
    ]

    var userLocation: CLLocation? {
        return locationManager.location
    }

    init(initialPosition: MapCameraPosition) {
        self.position = initialPosition
    }
    
    func onAppear() {
        locationManager.startUpdating()
    }
    
    /// 현재 위치로 지도 이동
    func moveToCurrentLocation() {
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
