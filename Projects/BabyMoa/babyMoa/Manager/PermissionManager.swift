//
//  PermissionManager.swift
//  BabyMoa
//
//  Created by 한건희 on 11/23/25.
//

import PhotosUI
import Photos

final class PermissionManager {
    static let shared = PermissionManager()
    
    private init() { }
    
    /// 사진 라이브러리 접근 권한 체크
    /// - Parameters:
    ///   - authorized: 권한이 있을 때 실행할 클로저
    ///   - denied: 권한이 없을 때 실행할 클로저
    func checkPhotoLibraryPermission(
        authorized: @escaping () -> Void = {},
        denied: @escaping () -> Void = {}
    ) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            authorized()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    switch newStatus {
                    case .authorized, .limited:
                        authorized()
                    default:
                        denied()
                    }
                }
            }
        default:
            denied()
        }
    }
}
