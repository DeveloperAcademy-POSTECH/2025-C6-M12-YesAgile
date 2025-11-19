//
//  PhotoLibraryPermissionHelper.swift
//  babyMoa
//
//  Created by Pherd on 11/18/25.
//

import Photos
import UIKit

/// 사진 라이브러리 접근 권한 관리 Helper
/// **역할**:
/// - 현재 권한 상태 확인
/// - 권한 요청 (첫 실행 시)
/// - Limited Access 사용자를 위한 추가 선택 UI 표시
/// - 설정 앱으로 이동
@MainActor
class PhotoLibraryPermissionHelper {

    /// 현재 사진 라이브러리 권한 상태 확인
    /// - Returns: PHAuthorizationStatus (.authorized, .limited, .denied, .restricted, .notDetermined)
    static func checkAuthorizationStatus() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    /// 권한 요청 (첫 실행 시)
    /// - Returns: 사용자가 선택한 권한 상태
    /// - Note: 시스템 팝업이 자동으로 표시됨 ("선택한 사진" / "모든 사진 허용" / "허용 안 함")
    static func requestAuthorization() async -> PHAuthorizationStatus {
        return await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }

    /// Limited Access 사용자에게 추가 사진 선택 UI 표시
    /// - Parameter viewController: 현재 화면의 ViewController
    /// - Note: Limited Access 상태에서만 의미가 있음
    static func presentLimitedLibraryPicker(
        from viewController: UIViewController
    ) {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(
            from: viewController
        )
    }

    /// 설정 앱으로 이동
    /// - Note: 사용자가 "설정 → BabyMoa → 사진"에서 권한을 변경할 수 있도록 안내
    static func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
