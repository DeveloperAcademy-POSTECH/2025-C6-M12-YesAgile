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
    
    init(coordinator: BabyMoaCoordinator) {
        _viewModel = StateObject(wrappedValue: HeightViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        ZStack{
            Color.white
            VStack(spacing: 0) {
                
                CustomNavigationBar(title: "키", leading: {
                    Button(action: {
                        viewModel.coordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                })
                
                Picker("탭 선택", selection: $selectedTab) {
                    ForEach(HeightTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 8)
                
                switch selectedTab {
                case .record:
                    HeightRecordListView(viewModel: viewModel)
                case .chart:
                    HeightChartView(viewModel: viewModel)
                }
                // 기록 추가 버튼
                Button("기록 추가", action: {
                    viewModel.coordinator.push(path: .newHeightAdd)
                })
                .buttonStyle(.defaultButton)
                .padding(.bottom, 40)
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
    HeightView(coordinator: BabyMoaCoordinator())
        .environmentObject(BabyMoaCoordinator())
}
