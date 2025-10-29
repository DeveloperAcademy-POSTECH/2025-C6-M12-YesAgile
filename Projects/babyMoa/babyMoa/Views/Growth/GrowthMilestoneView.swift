//
//  GrowthMilestoneView.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  성장 마일스톤 상세/편집 뷰 (사진 1장, 작성일, 메모, 저장)
//

import PhotosUI
import SwiftUI
import UIKit

struct GrowthMilestoneView: View {
    let milestone: GrowthMilestone
    let onSave: ((GrowthMilestone, UIImage?, String?, Date) -> Void)?
    let onDelete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss

    // Image
    @State private var pickedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showPhotoPicker: Bool = false

    // Date & memo
    @State private var selectedDate: Date
    @State private var memo: String
    @FocusState private var memoFocused: Bool

    // Sheet
    @State private var showDatePicker = false

    // 뒤로가기 확인 다이얼로그
    @State private var showDiscardAlert = false

    init(
        milestone: GrowthMilestone,
        onSave: ((GrowthMilestone, UIImage?, String?, Date) -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.milestone = milestone
        self.onSave = onSave
        self.onDelete = onDelete
        _selectedDate = State(initialValue: milestone.completedDate ?? Date())
        _memo = State(initialValue: milestone.description ?? "")
    }

    // 변경 여부
    private var hasChanges: Bool {
        // 사진 변경 체크
        let imgChanged = selectedImage != nil

        // 날짜 변경 체크 (같은 날짜인지 비교)
        let originalDate = milestone.completedDate ?? Date()
        let dateChanged = !Calendar.current.isDate(
            originalDate,
            inSameDayAs: selectedDate
        )

        // 메모 변경 체크
        let originalMemo = milestone.description ?? ""
        let memoChanged = originalMemo != memo

        return imgChanged || dateChanged || memoChanged
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 사진 (가로 여백 20, 가로 꽉)
                    photoSection
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    // 작성일
                    VStack(alignment: .leading, spacing: 8) {
                        Text("작성일")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)

                        Button(action: { showDatePicker = true }) {
                            HStack {
                                Text(formattedDate(selectedDate))
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding(16)
                            .background(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange, lineWidth: 1.5)
                            )
                        }
                    }
                    .padding(.horizontal, 20)

                    // 메모
                    VStack(alignment: .leading, spacing: 8) {
                        Text("메모")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)

                        ZStack(alignment: .topLeading) {
                            if memo.isEmpty {
                                Text("아이와 함께한 소중한 추억 메모를 입력 해주세요")
                                    .foregroundColor(.secondary)
                                    .padding(.top, 18)
                                    .padding(.leading, 22)
                            }
                            TextEditor(text: $memo)
                                .focused($memoFocused)
                                .frame(minHeight: 120)
                                .padding(12)
                                .background(Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.orange, lineWidth: 1.5)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .background(Color("Background"))
            .navigationTitle(milestone.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        // 변경사항이 있으면 확인 다이얼로그 표시
                        if hasChanges {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Font"))
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if onDelete != nil {
                        Button(action: { onDelete?() }) {
                            Image(systemName: "trash")
                                .foregroundColor(Color("Brand-50"))
                        }
                    }
                }
            }
            .confirmationDialog(
                "",
                isPresented: $showDiscardAlert,
                titleVisibility: .hidden
            ) {
                Button("변경 사항 폐기", role: .destructive) {
                    dismiss()
                }
                Button("계속 편집하기", role: .cancel) {}
            }
            .safeAreaInset(edge: .bottom) {
                // ✅ 컴포넌트: 저장 버튼
                GrowthBottomButton(title: "저장", isEnabled: hasChanges) {
                    onSave?(
                        milestone,
                        selectedImage,
                        memo.isEmpty ? nil : memo,
                        selectedDate
                    )
                    dismiss()
                }
                .background(Color("Background"))
            }
            .sheet(isPresented: $showDatePicker) {
                VStack(spacing: 0) {
                    // 헤더
                    HStack {
                        Button("취소") {
                            showDatePicker = false
                        }
                        .foregroundColor(.secondary)

                        Spacer()

                        Text("작성일 선택")
                            .font(.system(size: 17, weight: .semibold))

                        Spacer()

                        Button("완료") {
                            showDatePicker = false
                        }
                        .foregroundColor(Color("Brand-50"))
                    }
                    .padding()

                    Divider()

                    // Wheel Picker
                    DatePicker(
                        "작성일",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                }
                .presentationDetents([.height(320)])
            }
            // 사진 선택 모달 (레이아웃와 분리)
            .photosPicker(
                isPresented: $showPhotoPicker,
                selection: $pickedItem,
                matching: .images
            )
            // 선택 변경 시 이미지 갱신
            .onChange(of: pickedItem) { _, newValue in
                Task { @MainActor in
                    guard let newValue else { return }
                    if let data = try? await newValue.loadTransferable(
                        type: Data.self
                    ),
                        let uiImage = UIImage(data: data)
                    {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }

    // MARK: - Photo Section
    private var photoSection: some View {
        ZStack {
            if selectedImage == nil && (milestone.imageURL?.isEmpty ?? true) {
                // 이미지가 없을 때만 플레이스홀더 박스 표시
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(
                                Color("Brand-50").opacity(0.4),
                                lineWidth: 1
                            )
                    )
                    .frame(height: 250)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("사진을 선택하세요")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    )
            } else {
                // 이미지가 있을 때는 비율에 맞게 표시
                aspectFilledImage
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    )
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { showPhotoPicker = true }
    }

    @ViewBuilder
    private var aspectFilledImage: some View {
        if let uiImage = selectedImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        } else if let urlString = milestone.imageURL,
            let url = URL(string: urlString)
        {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                default:
                    EmptyView()
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy. MM. dd."
        return f.string(from: date)
    }
}

#Preview {
    GrowthMilestoneView(
        milestone: GrowthMilestone(
            title: "울음 외 소리내기",
            ageRange: "0~2개월",
            isCompleted: true,
            completedDate: Date()
        ),
        onSave: { _, _, _, _ in }
    )
}
