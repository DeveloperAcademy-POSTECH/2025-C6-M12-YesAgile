//
//  TermsAgreementHeaderView.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

struct TermsAgreementHeaderView: View {
    var cancelAction: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text("약관 동의")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black)
                Spacer()
            }
            
            HStack(spacing: 0) {
                Button(action: {
                    cancelAction()
                }) {
                    Image(systemName: "xmark")
                        .tint(.black)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.leading, 20)
        }
    }
}

#Preview {
    TermsAgreementHeaderView(cancelAction: {
      print("aa")
    })
}
