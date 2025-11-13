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
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomNavigationBar(title: "차아", leading: {
                    Button(action: {
                        viewModel.coordinator.pop()
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                })
                .padding(.bottom, 30)
                
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
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)

                
                EruptedTeethListView(viewModel: $viewModel)
                    .padding(.top, 25)
                Spacer()
            }
            .backgroundPadding(.horizontal)

            if isDatePickerPresented {
                CustomDatePicker(
                    selectedDate: $selectedDate,
                    isPresented: $isDatePickerPresented,
                    onConfirm: { newDate in
                        if let teethId = selectedTeethId {
                            Task {
                                let dateStr = DateFormatter.yyyyDashMMDashdd.string(from: newDate)
                                await viewModel.setTeethStatus(
                                    teethId: teethId,
                                    deletion: false,
                                    eruptedDate: dateStr
                                )
                            }
                        }
                    }
                )
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    TeethView(coordinator: BabyMoaCoordinator(), teethList: TeethData.mockData)
}
