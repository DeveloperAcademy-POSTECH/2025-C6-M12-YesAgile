//
//  HeightView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct HeightView: View {
    @State private var selectedTab: HeightTab = .record
    @StateObject private var viewModel: HeightViewModel
    
    init(coordinator: BabyMoaCoordinator, babyId: Int) {
        _viewModel = StateObject(wrappedValue: HeightViewModel(coordinator: coordinator, babyId: babyId))
    }
    
    var body: some View {
        ZStack{
            Color.background
            VStack(spacing: 0) {
                
                CustomNavigationBar(title: "키", leading: {
                    Button(action: {
                        viewModel.coordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                })
                
                ScrollView {
                    Picker("탭 선택", selection: $selectedTab) {
                        ForEach(HeightTab.allCases, id: \.self) { tab in
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
                            title: "아직 키 기록이 없어요.",
                            description: "첫 키 기록을 추가하고 아이의 성장을 기록해보세요.",
                            imageSystemName: "ruler.fill",
                            
                        )
                    } else {
                        switch selectedTab {
                        case .record:
                            HeightRecordListView(viewModel: viewModel)
                                .padding(.top, 20)
                        case .chart:
                            HeightChartView(viewModel: viewModel)
                                .padding(.top, 20)
                        }
                        
                    }
                    
                }
                .scrollIndicators(.hidden)
                
                // 기록 추가 버튼
                Button(action: {
                    viewModel.navigateToHeightAdd()

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
                await viewModel.fetchHeights()
            }
        }
       
    }
    
}

#Preview {
    let coordinator = BabyMoaCoordinator()
    return HeightView(coordinator: coordinator, babyId: 1)
}
