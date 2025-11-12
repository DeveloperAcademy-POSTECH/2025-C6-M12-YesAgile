//
//  HeightView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct HeightView: View {
    @EnvironmentObject var coordinator: BabyMoaCoordinator
    @State private var selectedTab: HeightTab = .record
    @State private var viewModel: HeightViewModel
    
    let babyId: Int
    
    init(babyId: Int) {
        self.babyId = babyId
        _viewModel = State(initialValue: HeightViewModel(babyId: babyId))
    }
    
    var body: some View {
        ZStack{
            Color.white
            VStack(spacing: 0) {
                
                CustomNavigationBar(title: "키", leading: {
                    Button(action: {
                        coordinator.pop()
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
                
                Button("기록 추가", action: {
                    
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
    HeightView(babyId: 1)
        .environmentObject(BabyMoaCoordinator())
}
