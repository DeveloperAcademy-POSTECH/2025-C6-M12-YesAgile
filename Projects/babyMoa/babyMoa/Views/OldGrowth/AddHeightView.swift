//
//  AddHeightView.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  키 기록 추가 뷰 (표준 NavigationStack 사용)
//

import SwiftUI

struct AddHeightView: View {
    @Environment(\.dismiss) private var dismiss

    let babyId: String
    let onSave: (Double, Date, String?) -> Void

    @State private var heightValue: Double = 50.0  // 기본값 50cm
    @State private var selectedDate = Date()
    @State private var memo: String = ""
    @State private var showDatePicker = false

    init(
        babyId: String,
        initialHeight: Double? = nil,
        initialDate: Date = Date(),
        initialMemo: String = "",
        onSave: @escaping (Double, Date, String?) -> Void
    ) {
        self.babyId = babyId
        self.onSave = onSave
        // 🔒 백킹 스토리지로 @State를 안전하게 초기화 (파라미터 의존 초기화 이슈 방지)
        _heightValue = State(initialValue: initialHeight ?? 50.0)
        _selectedDate = State(initialValue: initialDate)
        _memo = State(initialValue: initialMemo)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // ✅ 컴포넌트: 측정일
                        GrowthDateButton(date: selectedDate) {
                            showDatePicker = true
                        }

                        // ✅ 컴포넌트: 키 입력 (눈금자)
                        GrowthRulerInput(
                            value: $heightValue,
                            maxValue: 200.0,
                            unit: "cm",
                            label: "키"
                        )

                        // ✅ 컴포넌트: 메모
                        GrowthMemoField(text: $memo)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }

                Spacer()

                // ✅ 컴포넌트: 저장 버튼
                GrowthBottomButton(title: "저장") {
                    onSave(heightValue, selectedDate, memo.isEmpty ? nil : memo)
                    dismiss()
                }
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .navigationTitle("키 기록")
            .navigationBarTitleDisplayMode(.inline)
            //            .toolbar {
            //                ToolbarItem(placement: .navigationBarLeading) {
            //                    Button("취소") {
            //                        dismiss()
            //                    }
            //                }
            //            }
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
}

// MARK: - Preview

#Preview {
    AddHeightView(babyId: "test", initialHeight: 120.0) { height, date, memo in
        print("Height: \(height), Date: \(date), Memo: \(memo ?? "없음")")
    }
}
