//
//  PermissionManager.swift
//  babyMoa
//
//  Created by pherd on 11/23/25.
//

import Foundation
import Photos
import CoreLocation
import UIKit

/// 앱 권한 요청을 중앙에서 관리하는 매니저
/// - 위치, 사진, 알림 등 권한을 순차적으로 요청하거나 상태를 확인할 때 사용
@MainActor
final class PermissionManager: NSObject {
    static let shared = PermissionManager()
    
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// 앱 시작 시 필요한 주요 권한들을 순차적으로 요청
    /// - Note: MainTabView 진입 시점 등에 호출 권장
    func requestAllPermissions() async {
        // 1. 위치 권한 요청
        // 위치는 즉시 응답을 받기 어려우므로(Delegate 패턴), 요청만 보냄
        let locationManager = LocationManager()
        // LocationManager init에서 이미 requestWhenInUseAuthorization()를 호출하지만,
        // 명시적으로 여기서 한 번 더 호출하여 의도를 분명히 함
        // (실제로는 LocationManager 내부 로직을 따름)
        _ = locationManager
        
        // 2. 약간의 텀을 두고 사진 권한 요청 (위치 팝업과 겹치지 않게)
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
        
        // 3. 사진 권한 요청
        let photoStatus = await PhotoLibraryPermissionHelper.requestAuthorization()
        print("📸 Photo Permission Status: \(photoStatus.rawValue)")
        
        // 4. 알림 권한 등 추가 가능
    }
    
    /// 사진 권한 요청
    func requestPhotoPermission() async -> PHAuthorizationStatus {
        return await PhotoLibraryPermissionHelper.requestAuthorization()
    }
    
    /// 설정 화면으로 이동
    func openSettings() {
        PhotoLibraryPermissionHelper.openSettings()
    }
}

