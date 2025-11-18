//
//  SingleTeethView.swift
//  babyMoa
//
//  Created by 한건희 on 11/3/25.
//
import SwiftUI

struct SingleTeethView: View {
    var teeth: TeethData
    var rowIdx: Int
    var onTap: () -> Void

    var body: some View {
        VStack(spacing: 1) {
            Rectangle()
                .fill(teeth.erupted ? Color.white : Color.white.opacity(0.3))
                .frame(width: 30, height: 30)
                .cornerRadius(8, corners: rowIdx == 0 ? [.bottomLeft, .bottomRight] : [.topLeft, .topRight])
                .overlay(
                    Text("\(TeethInfo.teethNumber[teeth.teethId])")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(teeth.erupted ? .pink : .white)
                )
//                .cornerRadius(4)
                .onTapGesture {
                    onTap()
                }
                .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 1)
            
            // TODO: 제거
//            if teeth.erupted, let eruptedDate = teeth.eruptedDate {
//                Text(eruptedDate)
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//            }
        }
    }
}
