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
    
    @MainActor
    public func popToRoot() {
        paths.removeAll()
    }
    
    @MainActor
    public func pop() {
        paths.removeLast()
    }
    
    @MainActor
    public func pop(count: Int) {
        guard count > 0 else { return }
        let popCount = min(count, paths.count)
        paths.removeLast(popCount)
    }
}

enum CoordinatorPath: Hashable {
    case startBabyMoa
    case privacyConsent
    case login
    case mainTab
    case growth
    case allMilestones([[GrowthMilestone]])
    case height(babyId: Int)
    case weight(babyId: Int)
    case teeth(teethList: [TeethData])
    case journey
    // AddBaby and Guardian
    case addBaby
    case addBabyCreate
    case addBabyInvitaion
    case addBabyStatus(baby: AddBabyModel?, isBorn: Bool)
    //BabyMainView
    case babyMain
    case guardain
    case guardiainCode(viewModel: GuardianInvitationCodeViewModel)
    // New Height and Weight
    case newHeight
    case newHeightAdd
    case newWeight
    case newWeightAdd
}
