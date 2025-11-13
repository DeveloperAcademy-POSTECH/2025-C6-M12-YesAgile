//
//  HeightChartView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25. 
//

import SwiftUI
import Charts

struct HeightChartView: View {
    var viewModel: HeightViewModel
    
    @State private var selectedRecord: HeightRecordModel?
    
    private var lastRecord: HeightRecordModel? {
        viewModel.records.sorted(by: { $0.date > $1.date }).first
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Header for displaying selected/last record info
            VStack(alignment: .leading) {
                Text("마지막 측정")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                HStack {
                    Text(selectedRecord?.date ?? lastRecord?.date ?? "N/A")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text(selectedRecord?.valueText ?? lastRecord?.valueText ?? "N/A")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding(.bottom, 20)
            
            ScrollView(.horizontal) {
                Chart {
                    ForEach(viewModel.records.sorted(by: { $0.date < $1.date })) { record in
                        LineMark(
                            x: .value("날짜", record.date),
                            y: .value("키", record.value)
                        )
                        .foregroundStyle(Color.brandMain)
                        
                        PointMark(
                            x: .value("날짜", record.date),
                            y: .value("키", record.value)
                        )
                        .foregroundStyle(Color.brandMain)
                        .annotation(position: .top) {
                            Text(record.valueText)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Rule Mark for selected record
                    if let selectedRecord {
                        RuleMark(x: .value("Selected Date", selectedRecord.date))
                            .foregroundStyle(Color.gray)
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let location = value.location
                                        if let date: Date = proxy.value(atX: location.x) {
                                            let closestRecord = viewModel.records.min(by: {
                                                abs($0.dateValue.timeIntervalSince(date)) < abs($1.dateValue.timeIntervalSince(date))
                                            })
                                            selectedRecord = closestRecord
                                        }
                                    }
                                    .onEnded { _ in
                                        // Optionally reset selectedRecord or keep it
                                    }
                            )
                    }
                }
                .frame(width: max(400, CGFloat(viewModel.records.count) * 50), height: 250) // Dynamic width for scrolling
                .chartXAxis {
                    AxisMarks(values: .stride(by: .month)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.month(.abbreviated))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
            }
            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    let coordinator = BabyMoaCoordinator()
    let viewModel = HeightViewModel(coordinator: coordinator)
    viewModel.records = HeightRecordModel.mockData
    return HeightChartView(viewModel: viewModel)
}
