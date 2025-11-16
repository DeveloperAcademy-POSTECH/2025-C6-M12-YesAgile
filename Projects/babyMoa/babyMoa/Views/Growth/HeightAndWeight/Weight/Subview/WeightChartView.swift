//
//  WeightChartView.swift
//  BabyMoa
//
//  Created by Baba on 11/13/25.
//

import SwiftUI
import Charts

struct WeightChartView: View {
    var viewModel: WeightViewModel
    
    @State private var selectedRecord: WeightRecordModel?
    
    private var lastRecord: WeightRecordModel? {
        viewModel.records.sorted(by: { $0.dateValue > $1.dateValue }).first
    }
    
    // Y축 범위 계산
    private var yAxisRange: ClosedRange<Double> {
        guard !viewModel.records.isEmpty else { return 0...20 } // 몸무게에 맞는 기본 범위
        
        let values = viewModel.records.map { $0.value }
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 20
        
        let range = maxValue - minValue
        let padding = max(range * 0.2, 2.0) // 몸무게에 맞는 패딩
        
        let lowerBound = max(0, minValue - padding)
        let upperBound = maxValue + padding
        
        return lowerBound...upperBound
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
            
            // 차트 영역
            Chart {
                ForEach(viewModel.records.sorted(by: { $0.dateValue < $1.dateValue })) { record in
                    LineMark(
                        x: .value("날짜", record.dateValue),
                        y: .value("몸무게", record.value)
                    )
                    .foregroundStyle(Color.brandMain)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("날짜", record.dateValue),
                        y: .value("몸무게", record.value)
                    )
                    .foregroundStyle(Color.brandMain)
                    .symbolSize(100)
                }
                
                // Rule Mark for selected record
                if let selectedRecord {
                    RuleMark(x: .value("Selected Date", selectedRecord.dateValue))
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    
                    PointMark(
                        x: .value("날짜", selectedRecord.dateValue),
                        y: .value("몸무게", selectedRecord.value)
                    )
                    .foregroundStyle(Color.brandMain)
                    .symbolSize(150)
                    .annotation(
                        position: .top,
                        overflowResolution: .init(x: .fit, y: .automatic)
                    ) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selectedRecord.date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(selectedRecord.valueText)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                        }
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        }
                    }
                    
                    RuleMark(y: .value("Value", selectedRecord.value))
                        .lineStyle(StrokeStyle(lineWidth: 0.5, dash: [2]))
                        .foregroundStyle(.gray.opacity(0.3))
                }
            }
            .chartYScale(domain: yAxisRange)
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
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(String(format: "%.1f", doubleValue)) // 몸무게는 소수점 표시
                                .font(.caption)
                        }
                    }
                }
            }
            .frame(height: 250)
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let location = value.location
                                    if let date: Date = proxy.value(atX: location.x) {
                                        selectedRecord = viewModel.records.min(by: {
                                            abs($0.dateValue.timeIntervalSince(date)) <
                                            abs($1.dateValue.timeIntervalSince(date))
                                        })
                                    }
                                }
                                .onEnded { _ in
                                    // selectedRecord = nil
                                }
                        )
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    let coordinator = BabyMoaCoordinator()
    let viewModel = WeightViewModel(coordinator: coordinator)
    viewModel.records = WeightRecordModel.mockData
    return WeightChartView(viewModel: viewModel)
}
