//
//  AgeRangeMilestonesListView.swift
//  babyMoa
//
//  Created by 한건희 on 11/5/25.
//

import SwiftUI

struct AgeRangeMilestonesListView: View {
    @Binding var viewModel: AllMilestoneViewModel
    let row: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.allMilestones[row].first!.ageRange)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.orange50)
                .padding(.leading, 20)
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    Spacer().frame(width: 20)
                    ForEach(0..<viewModel.allMilestones[row].count, id: \.self) { col in
                        let milestone = viewModel.allMilestones[row][col]
                        MilestoneCardView(
                            milestone: milestone,
                            cardWidth: 110,
                            cardHeight: 147,
                            cardType: .small,
                            onTap: {
                                viewModel.milestoneCardTapped(
                                    selectedCardRowIdx: row,
                                    selectedCardColIdx: col
                                )
                            }
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.1), radius: 1)
                                
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        Spacer().frame(width: 20)
                    }
                }
            }
            .scrollIndicators(.never)
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}
