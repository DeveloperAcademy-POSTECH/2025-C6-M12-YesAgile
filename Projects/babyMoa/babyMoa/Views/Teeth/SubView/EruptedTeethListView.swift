//
//  EruptedTeethListView.swift
//  babyMoa
//
//  Created by 한건희 on 11/3/25.
//

import SwiftUI

struct EruptedTeethListView: View {
    @Binding var viewModel: TeethViewModel
    @State var isCalendarPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.sortedEruptedTeethList, id: \.self) { teeth in
                EruptedTeethRow(
                    teeth: teeth,
                    selectedDate: DateFormatter.yyyyDashMMDashdd.date(from: teeth.eruptedDate!)!,
                    dateSelectAction: { selectedDate in
                        Task {
                            await viewModel.setTeethStatus(teethId: teeth.teethId, deletion: false, eruptedDate: selectedDate)
                        }
                    }
                )
            }
        }
    }
}

struct EruptedTeethRow: View {
    var teeth: TeethData
    @State var isCalendarPresented: Bool = false
    @State var selectedDate: Date
    var dateSelectAction: (String) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("\(TeethInfo.teethNumber[teeth.teethId]) \(TeethInfo.teethName[TeethInfo.teethNumber[teeth.teethId]])")
                Spacer()
                Button(action: {
                    isCalendarPresented = true
                }) {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 120, height: 34)
                        .overlay(
                            Text(teeth.eruptedDate!.replacingOccurrences(of: "-", with: "."))
                                .font(.system(size: 17))
                                .foregroundStyle(.brand50)
                        )
                        .foregroundStyle(.gray80)
                }
            }
            .padding(.horizontal, 20)
            RoundedRectangle(cornerRadius: 999)
                .frame(height: 1)
                .foregroundStyle(.gray80)
        }
        .sheet(isPresented: $isCalendarPresented) {
            VStack(spacing: 20) {
                DatePicker(
                    "날짜 선택",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
//                Button("확인") {
//                    if let teethId = selectedTeethId {
//                        Task {
//                            let dateStr = DateFormatter.yyyyDashMMDashdd.string(from: selectedDate)
//                            await viewModel.setTeethStatus(
//                                teethId: teethId,
//                                deletion: false,
//                                eruptedDate: dateStr
//                            )
//                        }
//                    }
//                    isDatePickerPresented = false
//                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .padding(.bottom, 40)
            }
            .presentationDetents([.medium])
        }
        .onChange(of: selectedDate) {
            isCalendarPresented = false
            dateSelectAction(DateFormatter.yyyyDashMMDashdd.string(from: selectedDate))
        }
    }
}
