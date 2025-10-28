//
//  MonthPickerView.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  개월수 선택 Sheet 뷰
//

import SwiftUI

struct MonthPickerView: View {
    @Binding var selectedMonth: Int
    @Environment(\.dismiss) private var dismiss

    let months = Array(0...24)  // 0~24개월

    var body: some View {
        NavigationStack {
            List {
                ForEach(months, id: \.self) { month in
                    Button(action: {
                        selectedMonth = month
                        dismiss()
                    }) {
                        HStack {
                            Text("\(month)개월")
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedMonth == month {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("개월 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MonthPickerView(selectedMonth: .constant(6))
}
