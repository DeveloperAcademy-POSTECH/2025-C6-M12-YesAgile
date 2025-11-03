//
//  BabyMoaCoordinator.swift
//  babyMoa
//
//  Created by 한건희 on 11/1/25.
//

import SwiftUI

class BabyMoaCoordinator: ObservableObject {
    @Published var paths: [CoordinatorPath] = []
    
    @MainActor
    public func push(path: CoordinatorPath) {
        paths.append(path)
    }
    
    public func pop() {
        paths.removeLast()
    }
}

enum CoordinatorPath {
    case startBabyMoa
    case privacyConsent
    case login
    case growth
    case height
    case weight
    case journey
}
