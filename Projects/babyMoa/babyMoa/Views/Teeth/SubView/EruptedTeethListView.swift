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
                // 1. 치아 번호 (숫자): ID로 숫자를 가져옴 -> 정상
                Text("\(TeethInfo.teethNumber[teeth.teethId])")
                    .frame(width: 20)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.memoryPink) // 사용자 정의 컬러
                    .multilineTextAlignment(.leading)
                
                // 2. [수정됨] 치아 이름: ID로 바로 이름을 가져와야 함!
                Text(TeethInfo.teethName[teeth.teethId])
                    .font(.system(size: 17, weight: .semibold))

                Spacer()
                
                Button(action: {
                    isCalendarPresented = true
                }) {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 120, height: 34)
                        .overlay(
                            Text(teeth.eruptedDate?.replacingOccurrences(of: "-", with: ". ") ?? "")
                                .font(.system(size: 17))
                                .foregroundStyle(.brandMain) // 사용자 정의 컬러
                        )
                        .foregroundStyle(Color.gray45.opacity(0.12)) // 사용자 정의 컬러
                }
            }
            RoundedRectangle(cornerRadius: 999)
                .frame(height: 1)
                .foregroundStyle(.gray80) // 사용자 정의 컬러
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
                
                // 확인 버튼 등 UI 추가 가능
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .onChange(of: selectedDate) {
            // 날짜가 변경되면 창을 닫고 액션 실행
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
                TeethData(teethId: 0, eruptedDate: "2025-01-15", erupted: true),
                TeethData(teethId: 1, eruptedDate: "2025-01-20", erupted: true),
                TeethData(teethId: 2, eruptedDate: "2025-02-01", erupted: true),
                TeethData(teethId: 3, eruptedDate: "2025-02-10", erupted: true),
                TeethData(teethId: 4, eruptedDate: "2025-03-05", erupted: true),
                TeethData(teethId: 5, eruptedDate: "2025-03-12", erupted: true),
                TeethData(teethId: 6, eruptedDate: "2025-04-01", erupted: true),
                TeethData(teethId: 7, eruptedDate: "2025-04-10", erupted: true),
                TeethData(teethId: 8, eruptedDate: "2025-05-01", erupted: true),
                TeethData(teethId: 9, eruptedDate: "2025-05-15", erupted: true),
                TeethData(teethId: 10, eruptedDate: "2025-06-01", erupted: true),
                TeethData(teethId: 11, eruptedDate: "2025-06-10", erupted: true),
                TeethData(teethId: 12, eruptedDate: "2025-07-01", erupted: true),
                TeethData(teethId: 13, eruptedDate: "2025-07-15", erupted: true),
                TeethData(teethId: 14, eruptedDate: "2025-08-01", erupted: true),
                TeethData(teethId: 15, eruptedDate: "2025-08-10", erupted: true),
                TeethData(teethId: 16, eruptedDate: "2025-09-01", erupted: true),
                TeethData(teethId: 17, eruptedDate: "2025-09-15", erupted: true),
                TeethData(teethId: 18, eruptedDate: "2025-10-01", erupted: true),
                TeethData(teethId: 19, eruptedDate: "2025-10-10", erupted: true),
            ]
            
            _viewModel = State(initialValue: TeethViewModel(coordinator: BabyMoaCoordinator(), teethList: mockEruptedTeeth))
        }
        
        var body: some View {
            EruptedTeethListView(viewModel: $viewModel)
        }
    }
    
    return Preview()
}
