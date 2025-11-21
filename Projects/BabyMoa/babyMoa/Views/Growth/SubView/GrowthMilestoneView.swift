//
//  GrowthMilestoneView.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  성장 마일스톤 상세/편집 뷰 (사진 1장, 작성일, 메모, 저장)
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
    @StateObject private var imageLoaderViewModel = ImageLoaderViewModel()
    @State private var selectedImage: UIImage? = nil
    @State private var showPhotoPicker: Bool = false
    
    // Date & memo
    @State private var selectedDate: Date
    @State private var memo: String
    @FocusState private var isFocused: Bool

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
        _selectedImage = State(initialValue: milestone.image)
        _selectedDate = State(initialValue: milestone.completedDate ?? Date())
        _memo = State(initialValue: milestone.description ?? "")
    }
    
    // 변경 여부
    private var hasChanges: Bool {
        // 사진 변경 체크
        let imgChanged = selectedImage != milestone.image
        
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
                .ignoresSafeArea()

            VStack(spacing: 0) {
                CustomNavigationBar(
                    title: milestone.title,
                    leading: {
                        Button(action: {
                            self.endTextEditing() // 👈 뒤로가기 전 키보드 닫기
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                                
                        }
                        
                    },
                    trailing: {
                        Button(action: {
                            self.endTextEditing() // 👈 삭제 버튼 전 키보드 닫기
                            showDeleteDialog = true
                        }) {
                            Image(systemName: "trash")
                                
                        }
                    }
                    // 키보드가 올라왔을 때 네비게이션 바가 가려지지 않도록 배경 색을 설정합니다.
                    // (CustomNavigationBar 내부 구현에 따라 다름)
//                    backgroundColor: Color.background
                )
                ScrollViewReader { proxy in
                    
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
                                
                                
                                Button(selectedDate.yyyyMMdd, action: { // formattedDate 함수 대신 yyyyMMdd 사용
                                    self.endTextEditing() // 👈 날짜 피커 열기 전 키보드 닫기
                                    showDatePicker = true
                                })
                                .buttonStyle(.outlineMileButton)
                                
                            }
                            
                            // 메모
                            MemoTextEditor(
                                memo: $memo,
                                limit: 300,
                                isFocused: $isFocused,
                                placeholder: "아이와 함께한 소중한 추억 메모를 입력 해주세요"
                            )
                            
                            Spacer()
                            
                            GrowthBottomButton(title: "저장", isEnabled: hasChanges) {
                                self.endTextEditing() // 💡 수정 2: 저장 시 키보드 닫기 추가
                                onSave?(
                                    milestone,
                                    selectedImage,
                                    memo.isEmpty ? nil : memo,
                                    selectedDate
                                )
                                dismiss()
                            }
                            .id("bottom")
                        }
                        .padding(.bottom, 44)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    
                    // 메모 포커스 시 스크롤 조정 로직은 유지
                    .onChange(of: isFocused) {_, focused in
                        guard focused else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                proxy.scrollTo("bottom", anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .backgroundPadding(.horizontal)
            
            Spacer()

        }
        .ignoresSafeArea(edges: .top)
        // 💡 수정 1: simultaneousGesture 대신 onTapGesture를 사용하여 키보드 내리기 구현
        .onTapGesture {
            self.endTextEditing() // 👈 확장 메서드 사용
        }
        // -------------------------------------------------------------
        
        .animation(.spring, value: milestone.image)
        .animation(.spring, value: selectedImage)
        .sheet(isPresented: $showDatePicker) {
            VStack(spacing: 0) {
                HStack {
                    Button("취소") { showDatePicker = false }
                    .foregroundColor(.secondary)
                    Spacer()
                    Text("작성일 선택").font(.system(size: 17, weight: .semibold))
                    Spacer()
                    Button("완료") { showDatePicker = false }
                    .foregroundColor(Color.brand50)
                }
                .padding()
                Divider()
                DatePicker("작성일", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
            }
            .presentationDetents([.height(320)])
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $imageLoaderViewModel.imageSelection, // ViewModel에 바인딩
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
        .onChange(of: imageLoaderViewModel.imageToUpload) { _, newImage in
            // ImageLoaderViewModel이 로드한 이미지를 받아서 selectedImage에 할당
            if let newImage {
                self.selectedImage = newImage
            }
        }
    }
    
    // MARK: - Photo Section
    private var photoSection: some View {
        ZStack {
            // 1. 기본 플레이스홀더 (항상 배경에 존재)
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(
                            Color("Brand-50").opacity(0.4),
                            lineWidth: 1
                        )
                )
                .frame(height: 420) // 고정된 높이
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

            // 2. 실제 이미지 또는 일러스트 표시 (있을 경우)
            if let imageToDisplay = selectedImage ?? milestone.image {
                Image(uiImage: imageToDisplay)
                    .resizable()
                    .frame(height: 420) // 고정된 높이
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .clipped() // 프레임을 벗어나는 부분 자르기
            } else if let illustrationName = milestone.illustrationName {
                // 일러스트가 이미지 에셋 이름이라고 가정
                Image(illustrationName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .clipped()
            }
        }
        .contentShape(Rectangle()) // 전체 영역을 탭 가능하게
        .onTapGesture {
            self.endTextEditing() // 👈 PhotosPicker를 열기 전에 키보드 닫기
            showPhotoPicker = true // 탭하면 PhotosPicker 열기
        }
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
