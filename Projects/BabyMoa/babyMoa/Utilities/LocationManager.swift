//
//  LocationManager.swift
//  BabyMoaMap
//
//  Created by TaeHyeon Koo on 10/20/25.
//
// 사용자 현재 위치 추적 및 권한 관리

import Foundation
import CoreLocation
import Observation

/// 사용자의 현재 위치를 추적하고 관리하는 클래스
/// - 나침반 버튼 탭 시 현재 위치로 지도 이동에 사용
@Observable
class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    
    /// 사용자의 현재 위치 (nil이면 위치 미확보 또는 권한 없음)
    var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 권한 요청 (Info.plist의 NSLocationWhenInUseUsageDescription 필요)
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 위치 업데이트 시작 (JourneyView.onAppear에서 호출)
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    /// 위치 업데이트 수신 시 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    
    /// 위치 권한 상태 변경 시 호출
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || 
           manager.authorizationStatus == .authorizedAlways {
            startUpdating()
        }
    }
    
    /// 위치 오류 발생 시 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ 위치 오류: \(error.localizedDescription)")
    }
}

