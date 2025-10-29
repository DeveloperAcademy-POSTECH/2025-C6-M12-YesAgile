//
//  TeethView.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  치아 상세 뷰 - 위아래 10개씩 표시
//  컴포넌트화로 코드 간결화

import SwiftUI

struct TeethView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var teethRecords: [TeethRecord]
    let babyId: String

    @State private var selectedToothPosition: ToothPosition?
    @State private var newTeeth: [NewTooth] = []
    

    // 위쪽 10개 치아 (유치 기준)
    private let upperTeeth: [ToothPosition] = [
        .upperRight5, .upperRight4, .upperRight3, .upperRight2, .upperRight1,
        .upperLeft1, .upperLeft2, .upperLeft3, .upperLeft4, .upperLeft5,
    ]

    // 아래쪽 10개 치아 (유치 기준)
    private let lowerTeeth: [ToothPosition] = [
        .lowerRight5, .lowerRight4, .lowerRight3, .lowerRight2, .lowerRight1,
        .lowerLeft1, .lowerLeft2, .lowerLeft3, .lowerLeft4, .lowerLeft5,
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // 치아 다이어그램 (컴포넌트)
                        TeethDiagramCard(
                            upperTeeth: upperTeeth,
                            lowerTeeth: lowerTeeth,
                            isErupted: isErupted,
                            selectedPosition: selectedToothPosition,
                            onToothTap: handleToothTap
                        )
                        .popover(item: $selectedToothPosition) { position in
                            DatePicker(
                                "날짜 선택",
                                selection: bindingForDate(of: position),
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .padding()
                            .presentationDetents([.height(380)])
                        }

                        // 새로 난 치아 리스트
                        newTeethListView
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("치아")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                // 뷰가 사라질 때 자동으로 저장
                saveNewTeeth()
            }
        }
    }

    // MARK: - 새로 난 치아 리스트 (컴포넌트 활용)

    private var newTeethListView: some View {
        Group {
            if !newTeeth.isEmpty || !teethRecords.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("새로 난 치아")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("Font"))
                        .padding(.leading, 20)

                    // 새로 추가된 치아 (newTeeth)
                    ForEach(newTeeth) { tooth in
                        TeethRecordListItem(
                            name: tooth.displayName,
                            date: tooth.date,
                            onDateTap: {
                                selectedToothPosition = tooth.position
                            },
                            onDelete: {
                                deleteNewTooth(tooth)
                            }
                        )
                        .padding(.horizontal, 20)
                    }

                    // 기존에 저장된 치아 (teethRecords)
                    ForEach(teethRecords) { record in
                        TeethRecordListItem(
                            name: record.position.displayName,
                            date: record.date ?? Date(),
                            onDateTap: {
                                selectedToothPosition = record.position
                            },
                            onDelete: {
                                deleteExistingTooth(record)
                            }
                        )
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }

    // MARK: - Helper Methods

    /// 치아 탭 핸들러 - 새로 난 치아 추가
    private func handleToothTap(_ position: ToothPosition) {
        // 이미 기록된 치아이거나 새 리스트에 있으면 무시
        guard !isErupted(position) else { return }

        // 새로 난 치아 리스트에 추가 및 팝오버 오픈
        newTeeth.append(NewTooth(position: position, date: Date()))
        selectedToothPosition = position
    }

    /// 치아가 이미 난 상태인지 확인
    private func isErupted(_ position: ToothPosition) -> Bool {
        teethRecords.contains(where: { $0.position == position })
            || newTeeth.contains(where: { $0.position == position })
    }

    /// 선택된 치아의 날짜 바인딩
    private func bindingForDate(of position: ToothPosition) -> Binding<Date> {
        if let idx = newTeeth.firstIndex(where: { $0.position == position }) {
            return $newTeeth[idx].date
        }
        return .constant(Date())
    }

    /// 새로 추가된 치아 삭제 (newTeeth에서만)
    private func deleteNewTooth(_ tooth: NewTooth) {
        newTeeth.removeAll { $0.id == tooth.id }
        print("🗑️ 새 치아 삭제: \(tooth.displayName)")
    }

    /// 기존 치아 삭제 (teethRecords에서)
    private func deleteExistingTooth(_ record: TeethRecord) {
        teethRecords.removeAll { $0.id == record.id }
        print("🗑️ 기존 치아 삭제: \(record.position.displayName)")
    }

    /// 새로 난 치아를 teethRecords에 저장 (GrowthView에 즉시 반영)
    private func saveNewTeeth() {
        for tooth in newTeeth {
            // 이미 존재하는지 확인
            if !teethRecords.contains(where: { $0.position == tooth.position })
            {
                let record = tooth.toTeethRecord(babyId: babyId)
                teethRecords.append(record)
            }
        }
        print(
            "✅ 치아 기록 저장 완료: \(newTeeth.count)개 → teethRecords 총 \(teethRecords.count)개"
        )
    }
}

// MARK: - Preview

#Preview {
    TeethView(
        teethRecords: .constant([]),
        babyId: "test"
    )
}
