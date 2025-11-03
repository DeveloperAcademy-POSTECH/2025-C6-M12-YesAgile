//
//  MockLineTeethView.swift
//  babyMoa
//
//  Created by 한건희 on 11/3/25.
//

import SwiftUI

struct MockLineTeethView: View {
    @Binding var viewModel: GrowthViewModel
    var rowIdx: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<10, id: \.self) { colIdx in
                let teeth = viewModel.teethList[rowIdx * 10 + colIdx]
                // TODO: 이빨 난 시점에 따라 이빨 점점 나는거 보여지도록 하면 됩니다
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 28, height: 40)
                    .foregroundStyle(teeth.erupted ? .white : .white.opacity(0.3))
            }
        }
    }
}
