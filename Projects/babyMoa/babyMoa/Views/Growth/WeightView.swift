//
//  WeightView.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  몸무게 기록 목록 및 차트 뷰
//

import SwiftUI

struct WeightView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var weightRecords: [WeightRecord]
    let babyId: String

    @State private var selectedTab = 0  // 0: 기록, 1: 차트
    @State private var showAddWeight = false

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
                showAddWeight = true
            }) {
                Text("기록 추가")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color("Brand-50"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color("Background"))
        .navigationTitle("몸무게")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showAddWeight) {
            AddWeightView(babyId: babyId) { weight, date, memo in
                addWeightRecord(weight: weight, date: date, memo: memo)
            }
        }
    }

    // MARK: - 기록 리스트 뷰

    private var recordsListView: some View {
        ScrollView {
            if self.weightRecords.isEmpty {
                // ✅ 컴포넌트: 빈 상태 뷰
                GrowthEmptyStateView(
                    icon: "scalemass",
                    title: "아직 기록이 없어요",
                    subtitle: "아래 버튼을 눌러 첫 기록을 추가해보세요"
                )
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(self.weightRecords) { record in
                        // ✅ 컴포넌트: 기록 행
                        GrowthRecordRow(
                            ageText: getAgeText(for: record),
                            dateText: record.formattedDate,
                            difference: getPreviousWeight(for: record).map {
                                record.weight - $0
                            },
                            value: record.weight,
                            unit: "kg"
                        )

                        if record.id != self.weightRecords.last?.id {
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
                // - 월별/주별 몸무게 성장 추세
                // - SwiftCharts 사용
            }
        }
    }

    // MARK: - Helper Methods

    private func addWeightRecord(weight: Double, date: Date, memo: String?) {
        let newRecord = WeightRecord(
            babyId: babyId,
            weight: weight,
            date: date,
            memo: memo
        )
        weightRecords.insert(newRecord, at: 0)  // 최신순으로
    }

    private func getPreviousWeight(for record: WeightRecord) -> Double? {
        guard
            let index = weightRecords.firstIndex(where: { $0.id == record.id }),
            index < weightRecords.count - 1
        else {
            return nil
        }
        return weightRecords[index + 1].weight
    }

    private func getAgeText(for record: WeightRecord) -> String {
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
    WeightView(
        weightRecords: .constant([
            WeightRecord(babyId: "test", weight: 9.5, date: Date(), memo: nil),
            WeightRecord(
                babyId: "test",
                weight: 9.4,
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
