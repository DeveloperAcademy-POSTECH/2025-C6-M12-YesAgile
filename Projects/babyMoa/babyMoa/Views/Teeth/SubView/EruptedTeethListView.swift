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
                Text("\(TeethInfo.teethNumber[teeth.teethId])")
                    .frame(width: 20)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.memoryPink)
                    .multilineTextAlignment(.leading)
                Text(TeethInfo.teethName[TeethInfo.teethNumber[teeth.teethId]])
                    .font(.system(size: 17, weight: .semibold))

                    
                Spacer()
                Button(action: {
                    isCalendarPresented = true
                }) {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 120, height: 34)
                        .overlay(
                            Text(teeth.eruptedDate!.replacingOccurrences(of: "-", with: "."))
                                .font(.system(size: 17))
                                .foregroundStyle(.brandMain)
                        )
                        .foregroundStyle(Color.gray45.opacity(0.12))
                }
            }
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
        .ignoresSafeArea()
        .onChange(of: selectedDate) {
            isCalendarPresented = false
            dateSelectAction(DateFormatter.yyyyDashMMDashdd.string(from: selectedDate))
        }
    }
        
}

#Preview {
    struct Preview: View {
        @State var viewModel: TeethViewModel
        
        init() {
            let mockEruptedTeeth: [TeethData] = [
                TeethData(teethId: 4, eruptedDate: "2025-10-20", erupted: true),
                TeethData(teethId: 5, eruptedDate: "2025-10-25", erupted: true),
                TeethData(teethId: 14, eruptedDate: "2025-11-01", erupted: true),
                TeethData(teethId: 0, erupted: false),
                TeethData(teethId: 1, erupted: false),
            ]
            
            _viewModel = State(initialValue: TeethViewModel(coordinator: BabyMoaCoordinator(), teethList: mockEruptedTeeth))
        }
        
        var body: some View {
            EruptedTeethListView(viewModel: $viewModel)
        }
    }
    
    return Preview()
}
