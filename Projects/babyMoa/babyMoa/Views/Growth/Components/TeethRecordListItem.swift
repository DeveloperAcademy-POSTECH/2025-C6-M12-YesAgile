//
//  TeethRecordListItem.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  새로 난 치아 기록 리스트 아이템 컴포넌트

import SwiftUI

/// 새로 난 치아 기록 리스트 아이템
/// - 치아 이름 + 날짜 버튼
/// - 스와이프 삭제 지원
struct TeethRecordListItem: View {
    let name: String
    let date: Date
    let onDateTap: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // 치아 이름
            Text(name)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)

            Spacer()

            // 날짜 버튼
            Button(action: onDateTap) {
                Text(date.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("BrandPrimary"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color("BrandPrimary").opacity(0.12))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("삭제", systemImage: "trash")
            }
        }
    }
}

#Preview {
    List {
        TeethRecordListItem(
            name: "위 좌측 1번",
            date: Date(),
            onDateTap: {
                print("Date tapped")
            },
            onDelete: {
                print("Delete tapped")
            }
        )

        TeethRecordListItem(
            name: "아래 우측 3번",
            date: Date().addingTimeInterval(-86400 * 30),
            onDateTap: {},
            onDelete: {}
        )
    }
    .listStyle(.plain)
}
