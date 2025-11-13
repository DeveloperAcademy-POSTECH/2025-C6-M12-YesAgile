//
//  WeightView.swift
//  BabyMoa
//
//  Created by Baba on 11/13/25.
//

import SwiftUI

struct WeightView: View {
    @State private var selectedTab: WeightTab = .record
    @StateObject private var viewModel: WeightViewModel
    
    init(coordinator: BabyMoaCoordinator) {
        _viewModel = StateObject(wrappedValue: WeightViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        ZStack{
            Color.background
            VStack(spacing: 0) {
                
                CustomNavigationBar(title: "몸무게", leading: {
                    Button(action: {
                        viewModel.coordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                })
                
                Picker("탭 선택", selection: $selectedTab) {
                    ForEach(WeightTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 8)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("데이터 로딩 중...")
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else if viewModel.records.isEmpty {
                    EmptyRecordView(
                        title: "아직 몸무게 기록이 없어요.",
                        description: "첫 몸무게를 추가하고 아이의 성장을 기록해보세요.",
                        imageSystemName: "scalemass.fill",
                        
                    )
                } else {
                    switch selectedTab {
                    case .record:
                        WeightRecordListView(viewModel: viewModel)
                    case .chart:
                        WeightChartView(viewModel: viewModel)
                    }
                    
                }
                // 기록 추가 버튼
                Button("기록 추가", action: {
                    viewModel.coordinator.push(path: .newWeightAdd)
                })
                .buttonStyle(.defaultButton)
                .padding(.bottom, 40)
            }
            .backgroundPadding(.horizontal)
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                await viewModel.fetchWeights()
            }
        }
       
    }
    
}

#Preview {
    let coordinator = BabyMoaCoordinator()
    let viewModel = WeightViewModel(coordinator: coordinator)
    viewModel.records = WeightRecordModel.mockData
    return WeightView(coordinator: coordinator)
        .environmentObject(coordinator)
}
