//
//  TeethView.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  치아 상세 뷰 - 위아래 10개씩 표시
//  컴포넌트화로 코드 간결화

import SwiftUI

struct TeethView: View {
    @State var viewModel: TeethViewModel
    @State private var selectedTeethId: Int? = nil
    @State private var isDatePickerPresented = false
    @State private var selectedDate = Date()
    
    init(coordinator: BabyMoaCoordinator, teethList: [TeethData]) {
        viewModel = TeethViewModel(
            coordinator: coordinator,
            teethList: teethList
        )
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("치아")
                .font(.headline)
                .padding(.top, 20)
            
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.pink.opacity(0.5))
                .frame(height: 100)
                .overlay(
                    VStack {
                        // 윗줄(10개) + 아랫줄(10개)
                        ForEach(0..<2, id: \.self) { rowIdx in
                            LineTeethView(
                                viewModel: $viewModel,
                                selectedTeethId: $selectedTeethId,
                                isDatePickerPresented: $isDatePickerPresented,
                                rowIdx: rowIdx
                            )
                            if rowIdx == 0 {
                                Spacer()
                            }
                        }
                    }
                )
                .padding(.horizontal, 20)
                .clipped()
            EruptedTeethListView(viewModel: $viewModel)
            Spacer()
        }
        .sheet(isPresented: $isDatePickerPresented) {
            VStack(spacing: 20) {
                DatePicker(
                    "날짜 선택",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                Button("확인") {
                    if let teethId = selectedTeethId {
                        Task {
                            let dateStr = DateFormatter.yyyyDashMMDashdd.string(from: selectedDate)
                            await viewModel.setTeethStatus(
                                teethId: teethId,
                                deletion: false,
                                eruptedDate: dateStr
                            )
                        }
                    }
                    isDatePickerPresented = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .padding(.bottom, 40)
            }
            .presentationDetents([.medium])
        }
    }
}
