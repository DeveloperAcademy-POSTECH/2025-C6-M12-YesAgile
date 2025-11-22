//
//  JourneyAddView.swift
//  babyMoa
//
//  Created by pherd on 11/7/25.
//  Refactored on 11/22/25
//

import CoreLocation
import PhotosUI
import SwiftUI

struct JourneyAddView: View {
    let selectedDate: Date
    let onSave: (UIImage, String, Double, Double) -> Void
    let onDismiss: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: JourneyAddViewModel
    @State private var showImagePicker = false
    @State private var pickedItem: PhotosPickerItem? = nil
    @FocusState private var isMemoFocused: Bool

    init(
        selectedDate: Date,
        existingJourney: Journey? = nil,
        onSave: @escaping (UIImage, String, Double, Double) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.selectedDate = selectedDate
        self.onSave = onSave
        self.onDismiss = onDismiss
        _viewModel = State(initialValue: JourneyAddViewModel(journey: existingJourney))
    }

    var body: some View {
        @Bindable var viewModel = viewModel // ViewModel 바인딩 활성화

        ZStack(alignment: .top) {
            // 배경색 (Color.background가 없으면 시스템 배경색)
            Color(Color.background)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Custom Navigation Bar
                CustomNavigationBar(
                    title: selectedDate.formattedString,
                    leading: {
                        Button(action: {
                            dismissKeyboard()
                            onDismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                                .foregroundColor(.brand50)
                        }
                    },
                    trailing: { EmptyView() }, // 명시적으로 빈 뷰 전달
                    paddingTop: 10
                )
                .background(Color.background)

                ScrollView {
                    VStack(spacing: 20) {
                        // 사진 섹션
                        photoSection
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        // 메모 영역
                        VStack(alignment: .leading, spacing: 8) {
                            Text("여정 메모")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2)) // labelTextStyle 대체
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $viewModel.memo)
                                    .focused($isMemoFocused)
                                    .scrollContentBackground(.hidden)
                                    .font(.system(size: 14))
                                    .frame(height: 150)
                                    .padding(12)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.brand40.opacity(0.3), lineWidth: 2) // Color.brand40 대체
                                    )
                                
                                if viewModel.memo.isEmpty {
                                    Text("아이와 함께한 소중한 여정 메모를 입력 해주세요")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray.opacity(0.6))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 20)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer()

                        // 저장 버튼
                        Button {
                            guard let image = viewModel.selectedImage else { return }
                            dismissKeyboard()
                            let latitude = viewModel.extractedLocation?.coordinate.latitude ?? 0.0
                            let longitude = viewModel.extractedLocation?.coordinate.longitude ?? 0.0
                            
                            // 즉시 닫고 백그라운드에서 저장 (Fire and Forget)
                            onSave(image, viewModel.memo, latitude, longitude)
                            onDismiss()
                        } label: {
                            Text("저장")
                        }
                        .buttonStyle(viewModel.isSaveDisabled ? .noneButton : .defaultButton) // 활성화 시 defaultButton(brand50) 사용
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        .disabled(viewModel.isSaveDisabled)
                    }
                    .padding(.bottom, 44)
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
        .photosPicker(
            isPresented: $showImagePicker,
            selection: $pickedItem,
            matching: .images,
            preferredItemEncoding: .current
        )
        .onChange(of: pickedItem) { _, newValue in
            viewModel.handleImageSelection(newValue)
        }
        .alert("위치 정보 없음", isPresented: $viewModel.showLocationAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("사진에 위치 정보가 없어서 지도 위에 보이지 않습니다.")
        }
        .alert("사진 로드 실패", isPresented: $viewModel.showLoadErrorAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.loadErrorMessage)
        }
    }

    // MARK: - Photo Section
    private var photoSection: some View {
        ZStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .onTapGesture {
                        showImagePicker = true
                    }
            } else {
                // Placeholder
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white)
                    )
                    .overlay(
                        VStack(spacing: 10) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 36, weight: .medium))
                                .foregroundColor(Color.brand40) // Brand40 대체
                            Text("아이와 함께한 소중한 여정 사진을 등록 해주세요")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    )
                    .frame(height: 265)
                    .onTapGesture {
                        showImagePicker = true
                    }
            }
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Date Extension
private extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
}

// MARK: - Preview
#Preview("추가 모드") {
    JourneyAddView(
        selectedDate: Date(),
        onSave: { _, _, _, _ in },
        onDismiss: {}
    )
}

#Preview("수정 모드 (Mock Data)") {
    // Mock Data를 사용한 수정 모드 프리뷰
    // Journey.mockData가 존재하는지 확인하고 사용
    if let mockJourney = Journey.mockData.first {
        JourneyAddView(
            selectedDate: mockJourney.date,
            existingJourney: mockJourney,
            onSave: { _, _, _, _ in },
            onDismiss: {}
        )
    } else {
        Text("Mock Data가 없습니다.")
    }
}
