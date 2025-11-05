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
        }
    }
}
