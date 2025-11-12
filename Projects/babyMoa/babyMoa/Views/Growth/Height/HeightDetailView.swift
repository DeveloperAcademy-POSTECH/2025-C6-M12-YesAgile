//
//  HeightDetailView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct HeightDetailView: View {
    
    @State private var selectedTab: HeightTab = .record
    @State private var viewModel: HeightViewModel
    
    let babyId: Int
    
    init(babyId: Int) {
        self.babyId = babyId
        _viewModel = State(initialValue: HeightViewModel(babyId: babyId))
    }
    
    var body: some View {
        switch selectedTab {
        case .record:
            HeightRecordListView(viewModel: viewModel)
        case .chart:
            Spacer()
            Text("차트 뷰가 여기에 표시됩니다.")
            Spacer()
        }
    }
}


#Preview {
    HeightDetailView(babyId: 1)
}
