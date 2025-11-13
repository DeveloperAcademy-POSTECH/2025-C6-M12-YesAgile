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
    
    // 삭제 확인 다이얼로그
    @State private var showDeleteDialog = false
    
    init(
        milestone: GrowthMilestone,
        onSave: ((GrowthMilestone, UIImage?, String?, Date) -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.milestone = milestone
        self.onSave = onSave
        self.onDelete = onDelete
        selectedImage = milestone.image
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
        ZStack {
            Color.background
            VStack(spacing: 0) {
                // Create 일때 삭제(휴지통)을 클릭하면 취소되게 해야 한다.
                // 이미지를 불러와서 휴지통을 클릭하면 삭제되어야 한다.
                // 삭제 함수 찾아서 구현해야 한다.
                // 해야 될 것 많다.
                CustomNavigationBar(
                    title: milestone.title,
                    leading: {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                               
                        }
                        
                    },
                    trailing: {
                        Button(action: {
                            showDeleteDialog = true
                        }) {
                            Image(systemName: "trash")
                            
                        }
                    },
                )
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // 사진 (가로 여백 20, 가로 꽉)
                        photoSection
                            .padding(.top, 8)
                        
                        // 작성일
                        VStack(alignment: .leading, spacing: 8) {
                            Text("작성일")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.font)
                            
                            
                            Button(formattedDate(selectedDate), action: {
                                showDatePicker = true
                            })
                            .buttonStyle(.outlineMileButton)

                        }
                        
                        // 메모
                        VStack(alignment: .leading, spacing: 8) {
                            Text("메모")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)

                            ZStack(alignment: .topLeading) {
                                // 1) 실제 입력 영역
                                TextEditor(text: $memo)
                                    .focused($memoFocused)
                                    .frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)   // iOS 16+: 기본 배경 제거
                                    .background(Color.clear)

                                // 2) placeholder
                                if memo.isEmpty {
                                    Text("아이와 함께한 소중한 추억 메모를 입력 해주세요")
                                        .foregroundColor(.secondary)
                                        .padding(.top, 12)
                                        .padding(.leading, 16)
                                }
                            }
                            // 🔹 border 안쪽 여백 (텍스트와 테두리 사이)
                            .padding(12)
                            // ↳ 여기까지가 "내용 + 안쪽 여백"

                            // 🔹 둥근 흰 배경
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                            )
                            // 🔹 주황 외곽선 (안쪽으로만 그리기)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(.orange, lineWidth: 1.5)
                            )
                        }
                        
                        
                        GrowthBottomButton(title: "저장", isEnabled: hasChanges) {
                            onSave?(
                                milestone,
                                selectedImage,
                                memo.isEmpty ? nil : memo,
                                selectedDate
                            )
                            dismiss()
                        }
                    }
                    .padding(.bottom, 44)
                }
            }
            .backgroundPadding(.horizontal)

        }
        .ignoresSafeArea()
        .animation(.spring, value: milestone.image)
        .animation(.spring, value: selectedImage)
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
                    .foregroundColor(Color.brand50)
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
        .alert("성장 마일스톤", isPresented: $showDeleteDialog) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                Task {
                    if let onDelete {
                        onDelete()
                    }
                }
            }
        } message: {
            Text("삭제 하시겠습니까?")
        }
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
    
    // MARK: - Photo Section
    private var photoSection: some View {
        ZStack {
            if selectedImage == nil && milestone.image == nil {
                // 일러스트가 있으면 일러스트 표시, 없으면 플레이스홀더
                if let illustrationName = milestone.illustrationName {
                    MilestoneCardView(milestone: milestone, cardWidth: 353, cardHeight: 471, cardType: .big, onTap: {
                        showPhotoPicker = true
                    })
                } else {
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
                }
            } else {
                // 이미지가 있을 때는 비율에 맞게 표시
                aspectFilledImage
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    )
                    .onTapGesture {
                        showPhotoPicker = true
                    }
            }
        }
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private var aspectFilledImage: some View {
        if let uiImage = selectedImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        } else if let image = milestone.image
        {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
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
