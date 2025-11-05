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
            BabySelectionHeader()
            ScrollView {
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
                .padding(.bottom, 20)
                MilestoneSummaryView(viewModel: $viewModel)
                    .frame(height: 500)
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
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal) {
                HStack {
                    Spacer().frame(width: 20)
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
            .scrollIndicators(.never)
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

struct MilestoneCardView: View {
    let milestone: GrowthMilestone
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let cardType: MilestoneCardType
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            Image(milestone.illustrationName!) // TODO: url 구현하면 이미지 가져오는 것으로 바꿔야 함
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 10)
            VStack {
                Spacer().frame(height: cardType == .small ? 10 : 20)
                Text(milestone.completedDate != nil ? DateFormatter.yyyyMMdd.string(from: milestone.completedDate!) : "저는 곧 할 수 있어요")
                    .font(.system(size: cardType.dateFontSize, weight: .bold))
                Spacer()
                Text(milestone.title)
                    .font(.system(size: cardType.titleFontSize, weight: .bold))
                Spacer().frame(height: cardType == .small ? 10 : 20)
            }
            .foregroundStyle(.orange70)
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 10)
        )
        .onTapGesture {
            onTap()
        }
    }
}

/// 마일스톤 각 카드 항목 상 보여지는 폰트의 크기를 조절하기 위한 타입 값입니다.
enum MilestoneCardType {
    case small
    case big
    
    var dateFontSize: CGFloat {
        switch self {
        case .small:
            return 8
        case .big:
            return 18
        }
    }
    
    var titleFontSize: CGFloat {
        switch self {
        case .small:
            return 10
        case .big:
            return 30
        }
    }
}
