//
//  GrowthDatePickerSheet.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  공통 날짜 선택 Sheet 컴포넌트
//  ⚠️ 현재 사용 안 함 - 각 뷰에서 .datePickerStyle(.wheel) 직접 사용

//import SwiftUI

// ⚠️ 주석 처리: 너무 간단한 기능이므로 컴포넌트화 불필요
// 각 뷰에서 DatePicker에 .datePickerStyle(.wheel)만 추가하면 됨

/*
/// 날짜 선택 Sheet (Wheel Picker 스타일)
/// - 모든 성장 기록 입력에서 재사용 가능
struct GrowthDatePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    let title: String  // "측정일", "작성일" 등
    
    init(selectedDate: Binding<Date>, title: String = "측정일") {
        self._selectedDate = selectedDate
        self.title = title
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
            }
            .overlay(
                HStack {
                    Spacer()
                    Button("완료") { dismiss() }
                        .font(.system(size: 17))
                        .padding(.trailing, 20)
                }
            )
            .padding(.vertical, 16)
            
            Divider()
            
            // Wheel Picker
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            
            Spacer()
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    Text("Tap to show")
        .sheet(isPresented: .constant(true)) {
            GrowthDatePickerSheet(selectedDate: .constant(Date()))
        }
}
*/

