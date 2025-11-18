//
//  HeightRecordView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI
import Foundation

struct HeightRecordListView: View {
    @ObservedObject var viewModel: HeightViewModel
    
    init(viewModel: HeightViewModel) {
        self.viewModel = viewModel
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
                .onDelete(perform: viewModel.deleteHeightRecord)
                .background(Color.background)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            
            Spacer()
        }
        .background(Color.background)
    }
}

#Preview {
    let coordinator = BabyMoaCoordinator()
    let viewModel = HeightViewModel(coordinator: coordinator, babyId: 1)
    viewModel.records = HeightRecordModel.mockData
    return HeightRecordListView(viewModel: viewModel)
}
