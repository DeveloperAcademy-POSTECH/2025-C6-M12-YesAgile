//
//  HeightView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct HeightView: View {
    
    @State private var selectedTab: HeightTab = .record
    @State private var viewModel: HeightViewModel
    
    init(viewModel: HeightViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack{
            Color.white
            VStack(spacing: 0) {
                
                CustomNavigationBar(title: "키", leading: {
                    Button(action: {
                        
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
       
    }
    
}

#Preview {
    let viewModel = HeightViewModel(babyId: 1)
    return HeightView(viewModel: viewModel)
        .task {
            await viewModel.fetchHeights()
        }
}
