//
//  babyMoaApp.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI

@main
struct babyMoaApp: App {
    @AppStorage("hasCompletedBabySetup") private var hasCompletedBabySetup = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            BabyMoaRootView()
//            if hasCompletedBabySetup {
//                MainTabView()  // 아기 등록 완료 → 메인 화면
//            } else {
//                AddBabyView()  // 아기 미등록 → 등록 화면
//            }
        }
    }
}
