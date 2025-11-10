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

struct AllMilestoneView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock coordinator
        let coordinator = BabyMoaCoordinator()

        // Create mock GrowthMilestone data
        let mockMilestones: [[GrowthMilestone]] = [
            [
                GrowthMilestone(id: "milestone_0_0", title: "누워있기", ageRange: "0~2개월", isCompleted: false, completedDate: nil, illustrationName: "Baby01"),
                GrowthMilestone(id: "milestone_0_1", title: "손발 움직이기", ageRange: "0~2개월", isCompleted: false, completedDate: nil, illustrationName: "Baby02")
            ],
            [
                GrowthMilestone(id: "milestone_1_0", title: "목가누기", ageRange: "3~4개월", isCompleted: false, completedDate: nil, illustrationName: "Baby07"),
                GrowthMilestone(id: "milestone_1_1", title: "머리들기", ageRange: "3~4개월", isCompleted: false, completedDate: nil, illustrationName: "Baby08")
            ]
        ]

        AllMilestoneView(coordinator: coordinator, allMilestones: mockMilestones)
    }
}
