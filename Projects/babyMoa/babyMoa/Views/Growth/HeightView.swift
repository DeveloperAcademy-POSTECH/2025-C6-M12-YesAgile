//
//  HeightView.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  키 기록 목록 및 차트 뷰
//

import SwiftUI

struct HeightView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var heightRecords: [HeightRecord]
    let babyId: String

    @State private var selectedTab = 0  // 0: 기록, 1: 차트
    @State private var showAddHeight = false

    var body: some View {
        VStack(spacing: 0) {
            // 탭 선택
            Picker("", selection: $selectedTab) {
                Text("기록").tag(0)
                Text("차트").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)

            // 컨텐츠
            if selectedTab == 0 {
                recordsListView
            } else {
                chartView
            }

            Spacer()

            // 기록 추가 버튼 (하단 고정)
            Button(action: {
                showAddHeight = true
            }) {
                Text("기록 추가")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color("BrandPrimary"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color("BackgroundPrimary"))
        .navigationTitle("키")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddHeight) {
            AddHeightView(babyId: babyId) { height, date, memo in
                addHeightRecord(height: height, date: date, memo: memo)
            }
        }
    }

    // MARK: - 기록 리스트 뷰

    private var recordsListView: some View {
        ScrollView {
            if self.heightRecords.isEmpty {
                // ✅ 컴포넌트: 빈 상태 뷰
                GrowthEmptyStateView(
                    icon: "ruler",
                    title: "아직 기록이 없어요",
                    subtitle: "아래 버튼을 눌러 첫 기록을 추가해보세요"
                )
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(self.heightRecords) { record in
                        // ✅ 컴포넌트: 기록 행
                        GrowthRecordRow(
                            ageText: getAgeText(for: record),
                            dateText: record.formattedDate,
                            difference: getPreviousHeight(for: record).map {
                                record.height - $0
                            },
                            value: record.height,
                            unit: "cm"
                        )

                        if record.id != self.heightRecords.last?.id {
                            Divider()
                                .padding(.leading, 20)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
        }
    }

    // MARK: - 차트 뷰

    private var chartView: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("차트는 추후 구현 예정")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .padding(.top, 40)

                // TODO: 차트 구현
                // - 월별/주별 키 성장 추세
                // - SwiftCharts 사용
            }
        }
    }

    // MARK: - Helper Methods

    private func addHeightRecord(height: Double, date: Date, memo: String?) {
        let newRecord = HeightRecord(
            babyId: babyId,
            height: height,
            date: date,
            memo: memo
        )
        heightRecords.insert(newRecord, at: 0)  // 최신순으로
    }

    private func getPreviousHeight(for record: HeightRecord) -> Double? {
        guard
            let index = heightRecords.firstIndex(where: { $0.id == record.id }),
            index < heightRecords.count - 1
        else {
            return nil
        }
        return heightRecords[index + 1].height
    }

    private func getAgeText(for record: HeightRecord) -> String {
        // 생년월일 기준 개월 계산
        // TODO: 실제 아기 생년월일로 계산
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents(
            [.month],
            from: record.date,
            to: now
        )
        let months = abs(components.month ?? 0)
        return "\(months)개월"
    }
}

// MARK: - Preview

#Preview {
    HeightView(
        heightRecords: .constant([
            HeightRecord(babyId: "test", height: 73.1, date: Date(), memo: nil),
            HeightRecord(
                babyId: "test",
                height: 73.0,
                date: Calendar.current.date(
                    byAdding: .day,
                    value: -1,
                    to: Date()
                )!,
                memo: nil
            ),
        ]),
        babyId: "test"
    )
}
