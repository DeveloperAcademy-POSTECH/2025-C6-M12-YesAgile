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
    
    // MARK: - 임시 ViewModel. GrowthViewModel에 기능이 구현되면 삭제되어야 합니다.
    @StateObject private var babyMainViewModel = BabyMainViewModel(alertManager: AlertManager())
    
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
            BabyHeaderView(babyName: "김아기", buttonType: .none, onButtonTap: {})
                .onTapGesture {
                    isBabySelecting = true
                }
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
        .sheet(isPresented: $isBabySelecting) {
            // MARK: - 임시 해결책
            // GrowthViewModel에 babies 프로퍼티와 selectBaby(baby) 메소드가 없으므로,
            // BabyMainViewModel을 임시로 사용하여 sheet를 표시합니다.
            // 추후 GrowthViewModel에 해당 기능들이 구현되면 원래대로 복원해야 합니다.
            BabyListView(babies: babyMainViewModel.babies, onSelectBaby: { baby in
                babyMainViewModel.selectBaby(baby)
                // TODO: 여기서 선택된 baby 정보를 GrowthViewModel에도 알려주어야 합니다.
                // 예: viewModel.selectedBaby = babyMainViewModel.selectedBaby
                isBabySelecting = false // 아기 선택 후 시트 닫기
            }, onAddBaby: {
                isBabySelecting = false // 시트 닫기
                // 시트가 닫히는 애니메이션 후 화면을 전환하기 위해 약간의 딜레이를 줍니다.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    coordinator.push(path: .addBabyCreate)
                }
            })
            .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                if newHeight > 0 {
                    sheetHeight = newHeight
                }
            }
            .presentationDetents(
                sheetHeight > 0 ? [.height(sheetHeight)] : [.medium]
            )
            .presentationCornerRadius(25)
            .presentationDragIndicator(.visible)
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
