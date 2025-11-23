//
//  LocationManager.swift
//  BabyMoaMap
//
//  Created by TaeHyeon Koo on 10/20/25.
//
// 사용자 현재 위치 추적 및 권한 관리
//

import Foundation
import CoreLocation
import Observation

/// 사용자의 현재 위치를 추적하고 관리하는 클래스
/// - 나침반 버튼 탭 시 현재 위치로 지도 이동에 사용
@Observable
class LocationManager: NSObject {
    static let shared = LocationManager() // 싱글톤 인스턴스
    
    private let locationManager = CLLocationManager()
    
    /// 사용자의 현재 위치 (nil이면 위치 미확보 또는 권한 없음)
    var location: CLLocation?
    
    /// 현재 위치 권한 상태를 외부에서 읽을 수 있도록 노출
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 초기 권한 요청은 필요에 따라 여기서 하거나 외부에서 호출
    }
    
    /// 위치 업데이트 시작 (JourneyView.onAppear에서 호출)
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    /// 위치 권한 요청 (명시적으로 호출 가능)
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
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
        // 권한 상태가 변경되면 UI 업데이트를 위해 Observable 프로퍼티에 알림을 주거나
        // 필요한 작업을 수행 (여기서는 자동으로 startUpdating이 불리지는 않게 수정됨, 필요한 곳에서 호출)
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
