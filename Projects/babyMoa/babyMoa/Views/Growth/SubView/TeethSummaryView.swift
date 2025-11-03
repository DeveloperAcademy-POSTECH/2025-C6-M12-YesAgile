//
//  TeethSummaryView.swift
//  babyMoa
//
//  Created by 한건희 on 11/3/25.
//
import SwiftUI

struct TeethSummaryView: View {
    @Binding var viewModel: GrowthViewModel
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(.pink.opacity(0.5))
            .frame(height: 100)
            .overlay(
                VStack {
                    // 윗줄(10개) + 아랫줄(10개)
                    ForEach(0..<2, id: \.self) { rowIdx in
                        MockLineTeethView(viewModel: $viewModel, rowIdx: rowIdx)
                        if rowIdx == 0 {
                            Spacer()
                            Text("치아")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                    }
                }
            )
            .overlay(
                Image("Jeckki")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .offset(x: 105, y: -3)
            )
            .padding(.horizontal, 20)
            .clipped()
    }
}
