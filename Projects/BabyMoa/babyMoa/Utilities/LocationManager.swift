//
//  LocationManager.swift
//  BabyMoaMap
//
//  Created by TaeHyeon Koo on 10/20/25.
//
// map 관련

//import Foundation
//import CoreLocation
//import Combine
//
//class LocationManager: NSObject, ObservableObject {
//    private let locationManager = CLLocationManager()
//    
//    @Published var location: CLLocation?
//    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//    
//    func requestPermission() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//}
//
//extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        location = locations.last
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = manager.authorizationStatus
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("위치 관리자 오류: \(error.localizedDescription)")
//    }
//}
//
//
//
