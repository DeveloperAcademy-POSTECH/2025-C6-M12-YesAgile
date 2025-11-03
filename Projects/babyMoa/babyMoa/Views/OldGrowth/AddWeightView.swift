//
//  AddWeightView.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  몸무게 기록 추가 뷰 (컴포넌트화)
//

import SwiftUI

struct AddWeightView: View {
    @Environment(\.dismiss) private var dismiss

    let babyId: String
    let onSave: (Double, Date, String?) -> Void

    @State private var weightValue: Double = 10.0  // 기본값 10kg
    @State private var selectedDate = Date()
    @State private var memo: String = ""
    @State private var showDatePicker = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // ✅ 컴포넌트: 측정일
                        GrowthDateButton(date: selectedDate) {
                            showDatePicker = true
                        }

                        // ✅ 컴포넌트: 몸무게 입력 (눈금자)
                        GrowthRulerInput(
                            value: $weightValue,
                            maxValue: 20.0,
                            unit: "kg",
                            label: "몸무게"
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
                    onSave(weightValue, selectedDate, memo.isEmpty ? nil : memo)
                    dismiss()
                }
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .navigationTitle("몸무게 기록")
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
    AddWeightView(babyId: "test") { weight, date, memo in
        print("Weight: \(weight), Date: \(date), Memo: \(memo ?? "없음")")
    }
}
