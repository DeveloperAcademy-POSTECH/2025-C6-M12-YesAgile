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
    
    init(coordinator: BabyMoaCoordinator) {
        viewModel = GrowthViewModel(coordinator: coordinator)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            GrowthBabyHeader(showBabySelection: $isBabySelecting)
                .padding(.bottom, 20)
            HStack(spacing: 0) {
                Text("24개월간의,")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.orange50)
                Text(" 성장 마일스톤")
                    .font(.system(size: 24))
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            Spacer()
            MilestoneSummaryView(viewModel: $viewModel)
//            Text("마일스톤 뷰 들어가는 자리입니다.. 마일스톤도 다 데이터를 넘겨주는식으로 되어있어서 수정이 필요해 보여요")
            Spacer()
            Button(action: {
                viewModel.checkAllMilestonesButtonTapped()
            }) {
                RoundedRectangle(cornerRadius: 12)
                    .overlay(
                        Text("전체 성장 마일스톤 확인하기")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    )
                    .foregroundStyle(.brand50)
                    .frame(height: 60)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            
            HeightAndWeightView(
                height: $viewModel.latestHeight,
                weight: $viewModel.latestWeight,
                heightTapAction: {
                    viewModel.heightButtonTapped()
                },
                weightTapAction: {
                    viewModel.weightButtonTapped()
                }
            )
            .frame(height: 100)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Button(action: {
                viewModel.toothButtonTapped()
            }) {
                TeethSummaryView(viewModel: $viewModel)
                    .frame(height: 100)
            }
            .buttonStyle(.plain)
            Spacer().frame(height: 30)
        }
        .onAppear {
            Task {
                SelectedBaby.babyId = 1
                await viewModel.fetchAllGrowthData()
            }
        }
    }
}

struct MilestoneSummaryView: View {
    @Binding var viewModel: GrowthViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.beforeMilestoneButtonTapped()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 8)
                }
                
                Spacer()
                Text(viewModel.allMilestones[viewModel.selectedMonthIdx].first!.ageRange)
                Spacer()
                Button(action: {
                    viewModel.afterMilestoneButtonTapped()
                }) {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 8)
                }
            }
            .padding(.bottom, 20)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<viewModel.allMilestones[viewModel.selectedMonthIdx].count, id: \.self) { milestoneColIdx in
                        MilestoneCardView(milestone: viewModel.allMilestones[viewModel.selectedMonthIdx][milestoneColIdx], onTap: {
                            viewModel.selectedMilestoneAgeRangeIdx = viewModel.selectedMonthIdx
                            viewModel.selectedMilestoneIdxInAgeRange = milestoneColIdx
                            viewModel.isMilestoneEditingViewPresented = true
                        })
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isMilestoneEditingViewPresented) {
            GrowthMilestoneView(
                milestone: viewModel.allMilestones[viewModel.selectedMilestoneAgeRangeIdx][viewModel.selectedMilestoneIdxInAgeRange],
                onSave: { milestone, selectedImage, memo, selectedDate in
                    Task {
                        let editedMilestone = GrowthMilestone(id: milestone.id, title: milestone.title, ageRange: milestone.ageRange, completedDate: selectedDate, description: memo, illustrationName: milestone.illustrationName)
                        let isSaveCompleted = await viewModel.setMilestone(milestone: editedMilestone)
                        if isSaveCompleted {
                            viewModel.allMilestones[viewModel.selectedMilestoneAgeRangeIdx][viewModel.selectedMilestoneIdxInAgeRange] = editedMilestone
                        }
                    }
                },
                onDelete: {
                    
                }
            )
//            MilestoneEditingView(milestone: $viewModel.allMilestones[viewModel.selectedMilestoneAgeRangeIdx][viewModel.selectedMilestoneIdxInAgeRange])
        }
    }
}

struct MilestoneCardView: View {
    let milestone: GrowthMilestone
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            Image(milestone.illustrationName!) // TODO: url 구현하면 이미지 가져오는 것으로 바꿔야 함
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            VStack {
                Text(milestone.completedDate != nil ? DateFormatter.yyyyMMdd.string(from: milestone.completedDate!) : "저는 곧 할 수 있어요")
                Spacer()
                Text(milestone.title)
            }
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct MilestoneEditingView: View {
    @Binding var milestone: GrowthMilestone
    
    var body: some View {
        
    }
}// setMilestone 반환 true false 여부로 success 시 로컬도 업데이트 진행해야 함.
