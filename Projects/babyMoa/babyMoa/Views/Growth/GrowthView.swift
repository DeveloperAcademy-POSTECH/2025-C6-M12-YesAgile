//
//  GrowthView.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

struct GrowthView: View {
    @State var viewModel: GrowthViewModel
    @State var isBabySelecting: Bool = false
    
    let coordinator: BabyMoaCoordinator
    @State private var sheetHeight: CGFloat = .zero
    
    init(coordinator: BabyMoaCoordinator) {
        self.coordinator = coordinator
        self.viewModel = GrowthViewModel(coordinator: coordinator)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // BabySelectionHeader를 BabyHeaderView로 교체했습니다.
            // babyName 파라미터는 GrowthViewModel에 있는 실제 아기 이름 프로퍼티로 연결해야 합니다.
            
            ScrollView {
                
                VStack(spacing: 0){
                    HStack(spacing: 0) {
                        Text("24개월간의,")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.orange50)
                        Text("성장 마일스톤")
                            .font(.system(size: 24))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .padding(.bottom, 18)
                
                    MilestoneSummaryView(viewModel: $viewModel)
                        .frame(height: 500)
                    
                    
                    Button("전체 성장 마일스톤 확인하기", action: {
                        viewModel.checkAllMilestonesButtonTapped()
                    })
                    .buttonStyle(.fixedHeightButton)
                    .padding(.bottom, 40)
                    
                    HStack(spacing: 20){
                        Button(action: {
                            coordinator.push(path: .newHeight)
                        }, label: {
                            // 1. 기린 카드
                            CardItemView(title: "키", value: "37.5cm", backgroundColor: Color.orange50) {
                                // 👇 기린의 고유한 레이아웃 전달
                                Image("GiraffeNeck")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: .infinity)
                                    .padding(.trailing, 18)
                            }
                        })
                        
                        Button(action: {
                            coordinator.push(path: .newWeight)
                        }, label: {
                            // 2. 코끼리 카드
                            CardItemView(title: "몸무게", value: "10.2kg", backgroundColor: Color.green80) {
                                // 👇 코끼리의 고유한 레이아웃(VStack+Spacer) 전달
                                VStack {
                                    Spacer()
                                    Image("elephantCropImg")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 72)
                                        .padding(.trailing, 11)
                                }
                            }
                        })
                    }
                    .padding(.bottom, 20)
                    
                    
                    //                HeightAndWeightView(
                    //                    height: $viewModel.latestHeight,
                    //                    weight: $viewModel.latestWeight,
                    //                    heightTapAction: {
                    //                        viewModel.heightButtonTapped()
                    //                    },
                    //                    weightTapAction: {
                    //                        viewModel.weightButtonTapped()
                    //                    }
                    //                )
                    //                .frame(height: 100)
                    //                .padding(.bottom, 20)
                    
                    Button(action: {
                        viewModel.toothButtonTapped()
                    }) {
                        TeethSummaryView(viewModel: $viewModel)
                            .frame(height: 100)
                    }
                    .buttonStyle(.plain)
                    Spacer().frame(height: 30)
                }
            }
            .scrollIndicators(.hidden)
        }
        .backgroundPadding(.horizontal)
        .background(Color.background)
        .onAppear {
            Task {
                SelectedBaby.babyId = 1
//                await viewModel.fetchAllGrowthData()
            }
        }
    }
}

fileprivate struct MilestoneSummaryView: View {
    @Binding var viewModel: GrowthViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.beforeMilestoneButtonTapped()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .bold()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10)
                }
                
                Spacer()
                Text(viewModel.allMilestones[viewModel.selectedMonthIdx].first!.ageRange)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.orange50)
                Spacer()
                Button(action: {
                    viewModel.afterMilestoneButtonTapped()
                }) {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .bold()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10)
                }
            }
            
            ScrollView(.horizontal) {
                HStack {
                    //                    Spacer().frame(width: 10)
                    Spacer()
                    ForEach(0..<viewModel.allMilestones[viewModel.selectedMonthIdx].count, id: \.self) { milestoneColIdx in
                        MilestoneCardView(
                            milestone: viewModel.allMilestones[viewModel.selectedMonthIdx][milestoneColIdx],
                            cardWidth: 310,
                            cardHeight: 414,
                            cardType: .big,
                            onTap: {
                                viewModel.selectedMilestoneAgeRangeIdx = viewModel.selectedMonthIdx
                                viewModel.selectedMilestoneIdxInAgeRange = milestoneColIdx
                                viewModel.isMilestoneEditingViewPresented = true
                            }
                        )
                        .padding(.vertical, 20)
                        .padding(.trailing, 20)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .fullScreenCover(isPresented: $viewModel.isMilestoneEditingViewPresented) {
            GrowthMilestoneView(
                milestone: viewModel.selectedMilestone,
                onSave: { milestone, selectedImage, memo, selectedDate in
                    Task {
                        let editedMilestone = GrowthMilestone(id: milestone.id, title: milestone.title, ageRange: milestone.ageRange, image: selectedImage, completedDate: selectedDate, description: memo, illustrationName: milestone.illustrationName)
                        let isSaveCompleted = await viewModel.setMilestone(milestone: editedMilestone)
                        if isSaveCompleted {
                            viewModel.allMilestones[viewModel.selectedMilestoneAgeRangeIdx][viewModel.selectedMilestoneIdxInAgeRange] = editedMilestone
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

#Preview {
    // Create a mock coordinator for the preview
    let mockCoordinator = BabyMoaCoordinator()
    
    // Initialize GrowthView with the mock coordinator
    GrowthView(coordinator: mockCoordinator)
}
