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
        viewModel.records.sorted(by: { $0.dateValue > $1.dateValue }).first
    }
    
    // Y축 범위 계산
    private var yAxisRange: ClosedRange<Double> {
        guard !viewModel.records.isEmpty else { return 0...100 }
        
        let values = viewModel.records.map { $0.value }
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 100
        
        let range = maxValue - minValue
        let padding = max(range * 0.2, 5.0)
        
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
                    // 표시되는 날짜는 기존 String을 사용해도 무방합니다.
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
            
            // 차트 영역 - Apple 공식 방식
            Chart {
                ForEach(viewModel.records.sorted(by: { $0.dateValue < $1.dateValue })) { record in
                    LineMark(
                        x: .value("날짜", record.dateValue), // .date -> .dateValue
                        y: .value("키", record.value)
                    )
                    .foregroundStyle(Color.brandMain)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("날짜", record.dateValue), // .date -> .dateValue
                        y: .value("키", record.value)
                    )
                    .foregroundStyle(Color.brandMain)
                    .symbolSize(100)
                }
                
                // Rule Mark for selected record
                if let selectedRecord {
                    RuleMark(x: .value("Selected Date", selectedRecord.dateValue)) // .date -> .dateValue
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    
                    PointMark(
                        x: .value("날짜", selectedRecord.dateValue), // .date -> .dateValue
                        y: .value("키", selectedRecord.value)
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
                    
                    // 선택된 값 수평선
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
                            Text(String(format: "%.0f", doubleValue))
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
                                    // 선택 유지 또는 리셋
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
    let viewModel = HeightViewModel(coordinator: coordinator)
    viewModel.records = HeightRecordModel.mockData
    return HeightChartView(viewModel: viewModel)
}
