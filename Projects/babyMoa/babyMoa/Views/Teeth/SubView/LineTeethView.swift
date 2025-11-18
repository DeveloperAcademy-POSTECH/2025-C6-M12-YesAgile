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
    var rowIdx: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<10, id: \.self) { colIdx in
                let teeth = viewModel.teethList[rowIdx * 10 + colIdx]
                SingleTeethView(
                    teeth: teeth,
                    rowIdx: rowIdx,
                    onTap: {
                        Task {
                            if teeth.erupted {
                                // 이미 난 이 → 삭제
                                await viewModel.setTeethStatus(
                                    teethId: teeth.teethId,
                                    deletion: true,
                                    eruptedDate: nil
                                )
                            } else {
                                // 안 난 이 → 날짜 선택 시트
                                selectedTeethId = teeth.teethId
                                isDatePickerPresented = true
                            }
                        }
                    }
                )
            }
        }
    }
}
