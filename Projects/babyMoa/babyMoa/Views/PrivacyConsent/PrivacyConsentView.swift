//
//  PrivacyConsentView.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

struct PrivacyConsentView: View {
    @ObservedObject var coordinator: BabyMoaCoordinator
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    coordinator.pop()
                }) {
                    
                }
            }
            Text("개인정보 수집 및 이용 동의 관련 텍스트 ..")
        }
    }
}
