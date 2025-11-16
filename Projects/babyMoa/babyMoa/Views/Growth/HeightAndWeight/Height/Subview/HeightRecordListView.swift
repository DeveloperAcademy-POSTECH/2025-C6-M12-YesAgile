//
//  HeightRecordView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI
import Foundation

struct HeightRecordListView: View {
    // View가 ViewModel을 직접 생성하고 소유하도록 변경
    @StateObject private var viewModel: HeightViewModel
    
    // Coordinator와 같은 의존성은 init을 통해 외부에서 주입받음
    init(coordinator: BabyMoaCoordinator) {
        // _viewModel의 wrappedValue에 StateObject를 생성하여 할당
        self._viewModel = StateObject(wrappedValue: HeightViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(viewModel.records, id: \.id) { record in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(record.monthLabel ?? "")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.font)
                            Text(record.date)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(.secondLabel)
                        }
                        Spacer()
                        if let diffText = record.diffText {
                            Text(diffText)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.brandMain)
                                .padding(.trailing, 8)
                        }
                        Text(record.valueText)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.secondary)
                            .frame(width: 75, alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                        
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.gray50)
                        })
                    }
                    .listRowInsets(EdgeInsets())
                    .background(Color.background)
                    .padding(.vertical, 10)
                }
                .background(Color.background)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            
            Spacer()
        }
        .background(Color.background)
        .onAppear {
            // View가 나타날 때 데이터 로드
            Task {
                await viewModel.fetchHeights()
            }
        }
    }
}

#Preview {
    // Preview에서는 coordinator만 전달
    HeightRecordListView(coordinator: BabyMoaCoordinator())
}
