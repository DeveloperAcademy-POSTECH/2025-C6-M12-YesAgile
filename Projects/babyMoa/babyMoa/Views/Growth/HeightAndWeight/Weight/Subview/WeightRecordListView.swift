//
//  WeightRecordListView.swift
//  BabyMoa
//
//  Created by Baba on 11/13/25.
//

import SwiftUI

struct WeightRecordListView: View {
    @StateObject var viewModel: WeightViewModel
    
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
                    .background(Color.clear)
                    .padding(.vertical, 10)
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .padding(.top, 20)
            
            Spacer()
        }
    }
}

#Preview {
    WeightRecordListView(viewModel: WeightViewModel(coordinator: BabyMoaCoordinator()))
}
