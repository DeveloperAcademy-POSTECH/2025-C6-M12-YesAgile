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
                EmptyView()
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
                Image(viewModel.growthDetailType == .height ? "" : "") // MARK: 각각 이미지 넣기
                Text("아직 기록이 없어요")
                Text("아래 버튼을 눌러 첫 기록을 추가해보세요")
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
                Text("n개월")
                Text(DateFormatter.yyyyDashMMDashdd.string(from: growthData.date).replacingOccurrences(of: "-", with: "."))
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


//#Preview {
//    @Previewable @StateObject var coordinator = BabyMoaCoordinator()
//    
//    // MARK: 예시, [키, 몸무게] 통일해 뷰 구현하였고, 인자로 넘겨주는 ViewModel에 제너릭 타입 명시, 그리고 명시한 타입과 growthDetailType 은 동일하게 맞춰 보내주어야 합니다.
//    GrowthDetailView(viewModel: GrowthDetailViewModel<Height>(coordinator: coordinator, growthDetailType: .height, babyId: 9))
//}
