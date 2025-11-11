//
//  AllMilestoneView.swift
//  babyMoa
//
//  Created by 한건희 on 11/5/25.
//

import SwiftUI

struct AllMilestoneView: View {
    @State var viewModel: AllMilestoneViewModel
    
    init(coordinator: BabyMoaCoordinator, allMilestones: [[GrowthMilestone]]) {
        viewModel = AllMilestoneViewModel(coordinator: coordinator, allMilestones: allMilestones)
    }
    
    var body: some View {
        
        ZStack {
            
            Color.background
            
            VStack {
                //CustomerNavigationBar 추가하기
                CustomNavigationBar(title: "전체 성장 마일스톤", leading: {
                    Button(action: {
                        viewModel.coordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                })
                .backgroundPadding(.horizontal)
                
                ScrollView(.vertical) {
                    ForEach(0..<viewModel.allMilestones.count, id: \.self) { row in
                        AgeRangeMilestonesListView(viewModel: $viewModel, row: row)
                        Spacer().frame(height: 20)
                    }
                }
                .scrollIndicators(.never)
                .fullScreenCover(isPresented: $viewModel.isMilestoneEditingViewPresented) {
                    GrowthMilestoneView(
                        milestone: viewModel.selectedMilestone,
                        onSave: { milestone, selectedImage, memo, selectedDate in
                            Task {
                                let editedMilestone = GrowthMilestone(
                                    id: milestone.id,
                                    title: milestone.title,
                                    ageRange: milestone.ageRange,
                                    image: selectedImage,
                                    completedDate: selectedDate,
                                    description: memo,
                                    illustrationName: milestone.illustrationName
                                )
                                let isSaveCompleted = await viewModel.setMilestone(milestone: editedMilestone)
                                if isSaveCompleted {
                                    viewModel.allMilestones[viewModel.selectedCardRowIdx][viewModel.selectedCardColIdx] = editedMilestone
                                }
                            }
                        },
                        onDelete: {
                            Task {
                                await viewModel.deleteBabyMilestone()
                            }
                        }
                    )
                }
                
            }

        }
        .ignoresSafeArea()
    }
}
