//
//  BabyMoaRoot.swift
//  babyMoa
//
//  Created by 한건희 on 11/1/25.
//

import SwiftUI

struct BabyMoaRootView: View {
    @StateObject var coordinator = BabyMoaCoordinator()
    @StateObject var viewModel = BabyMoaRootViewModel()
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            VStack {
                
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                if viewModel.isUserAuthorized() {
                    coordinator.push(path: .growth)
                } else {
                    coordinator.push(path: .startBabyMoa)
                }
            }
            .navigationDestination(for: CoordinatorPath.self) { path in
                switch path {
                case .startBabyMoa:
                    BabyMoaStartView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                        
                case .login:
                    SignUpView(coordinator: coordinator)
                        .navigationBarBackButtonHidden()
                case .growth:
                    EmptyView()
                case .journey:
                    EmptyView()
                case .privacyConsent:
                    EmptyView()
                }
            }
        }
    }
}
