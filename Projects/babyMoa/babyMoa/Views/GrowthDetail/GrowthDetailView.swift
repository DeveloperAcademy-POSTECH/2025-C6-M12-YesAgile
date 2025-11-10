//
//  GrowthDetailView.swift
//  babyMoa
//
//  Created by 한건희 on 11/4/25.
//

import SwiftUI

struct GrowthDetailView<T: GrowthData>: View {
    @State var viewModel: GrowthDetailViewModel<T>
    @State var selectedTab: GrowthDetailViewType = .record
    @State var isRecordViewPresented: Bool = false
    
    init(coordinator: BabyMoaCoordinator, growthDetailType: GrowthDetailType, babyId: Int) {
        viewModel = GrowthDetailViewModel(
            coordinator: coordinator,
            growthDetailType: growthDetailType,
            babyId: babyId
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("성장", selection: $selectedTab) {
                Text("기록").tag(GrowthDetailViewType.record)
                Text("차트").tag(GrowthDetailViewType.chart)
            }
            .pickerStyle(.segmented)
            .padding()
            
            switch selectedTab {
            case .record:
                GrowthRecordListView(viewModel: $viewModel)
            case .chart:
                ChartView(viewModel: $viewModel)
            }
            Spacer()
            Button(action: {
                isRecordViewPresented = true
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 45)
                    .foregroundStyle(.brand40)
                    .overlay(
                        Text("기록 추가")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white)
                    )
            }
            .padding(.horizontal, 20)
        }
        .background(.gray.opacity(0.1))
        .onAppear {
            Task {
                await viewModel.fetchSingleGrowthDetailData()
            }
        }
        .sheet(isPresented: $isRecordViewPresented) {
            RecordGrowthView<T>(babyId: viewModel.babyId, onSave: { value, date, memo in
                Task {
                    await viewModel.addGrowthData(value: value, date: date, memo: memo)
                }
            })
        }
    }
}

enum GrowthDetailViewType {
    case record
    case chart
}

struct GrowthRecordListView<T: GrowthData>: View {
    @Binding var viewModel: GrowthDetailViewModel<T>
    
    var body: some View {
        VStack {
            if viewModel.growthDataList.count == 0 {
                Image(systemName: viewModel.growthDetailType == .height ? "ruler" : "powermeter") // MARK: 각각 이미지 넣기
                    .resizable()
                    .foregroundStyle(.gray)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: viewModel.growthDetailType == .height ? 87 : 70)
                    .padding(.bottom, 10)
                Text("아직 기록이 없어요")
                    .font(.system(size: 18, weight: .medium))
                    .padding(.bottom, 10)
                Text("아래 버튼을 눌러 첫 기록을 추가해보세요")
                    .font(.system(size: 14))
            }
            else {
                ScrollView {
                    ForEach(0..<viewModel.growthDataList.count, id: \.self) { idx in
                        // Text("\(data.value)") // TODO: 해당 위치 각 성장 기록 하나하나 들어가는 리스트 내부 요소(키, 몸무게)
                        GrowthDataRow(
                            growthData: $viewModel.growthDataList[idx],
                            previousGrowthValue: idx == viewModel.growthDataList.count - 1 ? 0 : viewModel.growthDataList[idx + 1].value
                        )
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.white)
                )
            }
        }
    }
}

struct GrowthDataRow<T: GrowthData>: View {
    @Binding var growthData: T
    let previousGrowthValue: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // TODO: 아기 태어난 날짜 로컬에 저장하도록 해서 개월 수 계산 가능하도록 해야함
                Text("n개월") // 저장된 birthDay
                Text(DateFormatter.yyyyMMdd.string(from: growthData.date))
            }
            .padding(.leading, 10)
            Spacer()
            Text(String(format: "%.2f", growthData.value - previousGrowthValue))
                .padding(.trailing, 5)
            Text(String(format: "%.2f", growthData.value))
            Text(T.self == Height.self ? "cm" : "kg")
                .padding(.trailing, 10)
        }
        .frame(height: 100)
    }
}

struct RecordGrowthView<T: GrowthData>: View {
    @Environment(\.dismiss) private var dismiss

    let babyId: Int
    let onSave: (Double, Date, String?) -> Void

    @State private var growthValue: Double = 50.0  // 기본값 50cm
    @State private var selectedDate = Date()
    @State private var memo: String = ""
    @State private var showDatePicker = false

    init(
        babyId: Int,
        initialHeight: Double? = nil,
        initialDate: Date = Date(),
        initialMemo: String = "",
        onSave: @escaping (Double, Date, String?) -> Void
    ) {
        self.babyId = babyId
        self.onSave = onSave
        _growthValue = State(initialValue: initialHeight ?? 50.0)
        _selectedDate = State(initialValue: initialDate)
        _memo = State(initialValue: initialMemo)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    GrowthDateButton(date: selectedDate) {
                        showDatePicker = true
                    }

                    GrowthRulerInput(
                        value: $growthValue,
                        maxValue: T.self == Height.self ? 50.0 : 10.0,
                        unit: T.self == Height.self ? "cm" : "kg",
                        label: T.self == Height.self ? "키" : "몸무게"
                    )

                    GrowthMemoField(text: $memo)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }

            Spacer()
            GrowthBottomButton(title: "저장") {
                onSave(growthValue, selectedDate, memo.isEmpty ? nil : memo)
                dismiss()
            }
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
        .sheet(isPresented: $showDatePicker) {
            DatePicker(
                "측정일",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .presentationDetents([.medium])
        }
    }
}

import Charts

struct ChartView<T: GrowthData>: View {
    @Binding var viewModel: GrowthDetailViewModel<T>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Chart {
                ForEach(Array(viewModel.growthDataList.sorted { $0.date < $1.date }.enumerated()), id: \.element.id) { index, data in
                    // 영역 (그라데이션)
                    AreaMark(
                        x: .value("Index", index),
                        y: .value("Value", data.value)
                    )
                    .interpolationMethod(.linear)
                    .foregroundStyle(
                        .linearGradient(
                            colors: T.self == Height.self ? [
                                Color.orange.opacity(0.5),
                                Color.orange.opacity(0.1),
                                .clear
                            ] : [
                                Color.green.opacity(0.5),
                                Color.green.opacity(0.1),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // 선
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Value", data.value)
                    )
                    .interpolationMethod(.linear)
                    .foregroundStyle(T.self == Height.self ? .orange : .green)
                    
                    PointMark(
                        x: .value("Index", index),
                        y: .value("Value", data.value)
                    )
                    .foregroundStyle(T.self == Height.self ? .orange : .green)
                    .symbolSize(25)
                }
            }
            .padding(.top, 20)
            .chartXAxis {
                AxisMarks(values: Array(0..<viewModel.growthDataList.count)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let intValue = value.as(Int.self),
                           intValue < viewModel.growthDataList.count {
                            let date = viewModel.growthDataList[viewModel.growthDataList.count - (intValue + 1)].date
                            Text(date.yyyyMMdd)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            // 일정한 간격이므로, 데이터 개수에 따라 폭 계산
            .frame(width: CGFloat(viewModel.growthDataList.count) * 70 < UIScreen.main.bounds.width ? UIScreen.main.bounds.width - 40 : CGFloat(viewModel.growthDataList.count) * 70, height: 300)
            .padding(.horizontal)
        }
    }
}
