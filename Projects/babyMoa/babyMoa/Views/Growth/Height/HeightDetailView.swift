//
//  HeightDetailView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct HeightDetailView: View {
    
    @State private var selectedTab: HeightTab = .record
    @State private var viewModel = HeightViewModel()
    
    
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
    HeightDetailView()
}
