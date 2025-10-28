//
//  GrowthView.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  성장 기록 메인 화면 - 컴포넌트 기반 구조
//

import SwiftUI

struct GrowthView: View {
    // MARK: - State Properties

    @State private var viewModel = GrowthViewModel()
    @State private var showBabySelection = false
    @State private var showAllMilestones = false
    @State private var showMonthPicker = false
    @State private var showHeightView = false
    @State private var showWeightView = false
    @State private var showTeethDetail = false
    @State private var editingMilestone: GrowthMilestone? = nil

    // MARK: - Body

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            VStack(spacing: 0) {
                // 아기 선택 헤더
                GrowthBabyHeader(showBabySelection: $showBabySelection)

                ScrollView {
                    VStack(spacing: 16) {
                        // 성장 마일스톤 카드
                        GrowthMilestoneCard(
                            selectedMonth: $viewModel.selectedMonth,
                            milestones: viewModel.currentMilestones,
                            localImageProvider: { id in
                                viewModel.milestoneLocalImages[id]
                            },
                            onMonthTap: { showMonthPicker = true },
                            onMilestoneTap: { milestone in
                                editingMilestone = milestone
                            }
                        )

                        // 키/몸무게 버튼
                        metricButtons

                        // 치아 카드
                        TeethCard(
                            teethRecords: viewModel.teethRecords,
                            onTap: { showTeethDetail = true },
                            illustration: Image("Jeckki")
                        )

                        // 성장 여정 안내 섹션
                        growthJourneySection

                        // 전체 마일스톤 버튼
                        AllMilestonesButton {
                            showAllMilestones = true
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
                .background(Color("BackgroundPrimary"))

                // 네비게이션 링크 (isActive)
                NavigationLink(isActive: $showHeightView) {
                    HeightView(
                        heightRecords: $viewModel.heightRecords,
                        babyId: viewModel.selectedBabyId
                    )
                } label: {
                    EmptyView()
                }
                .hidden()

                NavigationLink(isActive: $showWeightView) {
                    WeightView(
                        weightRecords: $viewModel.weightRecords,
                        babyId: viewModel.selectedBabyId
                    )
                } label: {
                    EmptyView()
                }
                .hidden()

                NavigationLink(isActive: $showAllMilestones) {
                    AllMilestonesView(
                        allMilestones: viewModel.allMilestones,
                        localImageProvider: { id in
                            viewModel.milestoneLocalImages[id]
                        }
                    )
                } label: {
                    EmptyView()
                }
                .hidden()
            }
            .actionSheet(isPresented: $showBabySelection) {
                babySelectionSheet
            }
            .sheet(isPresented: $showMonthPicker) {
                MonthPickerView(selectedMonth: $viewModel.selectedMonth)
            }
            .sheet(item: $editingMilestone) { item in
                GrowthMilestoneView(milestone: item) {
                    updated,
                    image,
                    memo,
                    date in
                    // ViewModel을 통해 저장 (이미지 업로드 + 메타데이터 업데이트)
                    Task {
                        await viewModel.saveMilestone(
                            updated,
                            image: image,
                            memo: memo,
                            date: date
                        )
                    }
                }
            }
            // 치아 기록 NavigationLink
            NavigationLink(isActive: $showTeethDetail) {
                TeethView(
                    teethRecords: $viewModel.teethRecords,
                    babyId: viewModel.selectedBabyId
                )
            } label: {
                EmptyView()
            }
            .hidden()
            .onChange(of: showTeethDetail) { _, isPresented in
                // TeethView가 닫힐 때 (false로 변경) 저장
                if !isPresented {
                    viewModel.saveTeethRecords()
                }
            }
        }
    }

    // MARK: - Subviews

    private var growthJourneySection: some View {
        VStack {
            // 아기 이미지 (Assets에서 참조)
            Image("baby_milestone_illustration")  // Assets에 이 이름으로 이미지 추가
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)

            // 상단 텍스트
            Text("저는 매일 쑥쑥 크고 있어요")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("BrandPrimary"))

            // 메인 타이틀
            HStack(spacing: 4) {
                Text("그동안 함께,")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("TextPrimary"))

                Text("해낸 성장 여정은?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("TextPrimary"))
            }

            // 설명 텍스트
            Text(
                "때로는 시간이 빠르게 가기도 하고, 때로는 시간이 느리게 가기도 해요. 가끔 저를 보며 \"언제 저렇게 컸지?\" 라는 생각이 들지 않으셨나요? 저는 매일 매일 쑥!쑥! 클게요. 저의 성장 여정을 계속 함께해주세요!"
            )
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(Color("TextPrimary").opacity(0.7))
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 24)
    }

    private var metricButtons: some View {
        HStack(spacing: 12) {
            GrowthMetricButton(
                title: "키",
                icon: "ruler",
                latestValue: viewModel.latestHeight.map {
                    "\(String(format: "%.1f", $0.height))cm"
                },
                latestDate: viewModel.latestHeight?.formattedDate,
                color: Color("BrandTertiary"),
                onTap: { showHeightView = true },
                illustration: Image("GiraffeNeck")
            )
            .frame(maxWidth: .infinity)  // 동일한 너비로 분배

            GrowthMetricButton(
                title: "몸무게",
                icon: "scalemass",
                latestValue: viewModel.latestWeight.map {
                    "\(String(format: "%.1f", $0.weight))kg"
                },
                latestDate: viewModel.latestWeight?.formattedDate,
                color: Color("HeightSecondary"),
                onTap: { showWeightView = true },
                illustration: Image("ElephantNeck")
            )
            .frame(maxWidth: .infinity)  // 동일한 너비로 분배
        }
    }

    private var babySelectionSheet: ActionSheet {
        ActionSheet(
            title: Text("아기 선택"),
            buttons: [
                .default(Text("아기 이름")) {},
                .default(Text("+ 아기 추가")) {},
                .cancel(),
            ]
        )
    }
}

#Preview {
    GrowthView()
}
