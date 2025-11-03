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
            Text("마일스톤 뷰 들어가는 자리입니다.. 마일스톤도 다 데이터를 넘겨주는식으로 되어있어서 수정이 필요해 보여요")
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
                SelectedBaby.babyId = 9
                await viewModel.fetchAllGrowthData()
            }
        }
    }
}



