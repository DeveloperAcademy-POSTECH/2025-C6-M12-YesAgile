//
//  GrowthDateButton.swift
//  babyMoa
//
//  Created by 한건희 on 11/4/25.
//

import SwiftUI

struct GrowthDateButton: View {
    let label: String
    let date: Date
    let onTap: () -> Void

    init(label: String = "측정일", date: Date, onTap: @escaping () -> Void) {
        self.label = label
        self.date = date
        self.onTap = onTap
    }

    var body: some View {
        GrowthLabeledField(label: label) {
            Button(action: onTap) {
                HStack {
                    Text(formattedDate)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(16)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange, lineWidth: 1.5)
                )
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd."
        return formatter.string(from: date)
    }
}
