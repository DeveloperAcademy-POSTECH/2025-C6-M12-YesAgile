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
    
    init(coordinator: BabyMoaCoordinator, babyId: Int) {
        _viewModel = StateObject(wrappedValue: WeightViewModel(coordinator: coordinator, babyId: babyId))
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
                
                
                ScrollView {
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
                                .padding(.top, 20)
                        case .chart:
                            WeightChartView(viewModel: viewModel)
                                .padding(.top, 20)

                        }
                        
                    }
                }
                .scrollIndicators(.hidden)
                
                // 기록 추가 버튼
                Button(action: {
                    viewModel.navigateToWeightAdd()

                }, label: {
                    Text("기록 추가")
                })
                .buttonStyle(.defaultButton)
                .padding(.bottom, 44)
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
    return WeightView(coordinator: coordinator, babyId: 1)
}
