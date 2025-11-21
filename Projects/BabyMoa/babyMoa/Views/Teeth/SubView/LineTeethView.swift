//
//  LineTeethView.swift
//  babyMoa
//
//  Created by 한건희 on 11/3/25.
//

import SwiftUI

struct LineTeethView: View {
    @Binding var viewModel: TeethViewModel
    @Binding var selectedTeethId: Int?
    @Binding var isDatePickerPresented: Bool
    @Binding var isDeleteAlertPresented: Bool
    @Binding var teethIdToDelete: Int?
    var rowIdx: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<10, id: \.self) { colIdx in
                let teeth = viewModel.teethList[rowIdx * 10 + colIdx]
                SingleTeethView(
                    teeth: teeth,
                    rowIdx: rowIdx,
                    onTap: {
                        if teeth.erupted {
                            // 이미 난 이 → 삭제 확인 알림창 띄우기
                            teethIdToDelete = teeth.teethId
                            isDeleteAlertPresented = true
                        } else {
                            // 안 난 이 → 날짜 선택 시트
                            selectedTeethId = teeth.teethId
                            isDatePickerPresented = true
                        }
                    }
                )
            }
        }
    }
}
