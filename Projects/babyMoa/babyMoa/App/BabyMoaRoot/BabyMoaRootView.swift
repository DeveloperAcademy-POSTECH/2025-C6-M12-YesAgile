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
            .onAppear {
                if viewModel.isUserAuthorized() {
                    coordinator.push(path: .growth)
                } else {
                    coordinator.push(path: .login)
                }
            }
            .navigationDestination(for: CoordinatorPath.self) { path in
                switch path {
                case .login:
                    EmptyView()
                case .growth:
                    EmptyView()
                case .journey:
                    EmptyView()
                }
            }
        }
    }
}
