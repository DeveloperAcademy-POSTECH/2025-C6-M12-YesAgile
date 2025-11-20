//
//  JourneyAddView.swift
//  BabyMoaJourney
//
//  Created by pherd on 11/7/25.
//
import CoreLocation
import PhotosUI  // PhotosPicker, PHAuthorizationStatus 포함
import SwiftUI

struct JourneyAddView: View {
    let selectedDate: Date
    let photoAccessStatus: PHAuthorizationStatus
    let onSave: (UIImage, String, Double, Double) -> Void
    let onDismiss: () -> Void

    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss

    // MARK: - State (ViewModel)
    @State private var viewModel: JourneyAddViewModel
    @State private var showImagePicker = false
    @State private var pickedItem: PhotosPickerItem? = nil
    @FocusState private var isMemoFocused: Bool

    // MARK: - Init

    init(
        selectedDate: Date,
        photoAccessStatus: PHAuthorizationStatus,
        existingJourney: Journey? = nil,
        onSave: @escaping (UIImage, String, Double, Double) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.selectedDate = selectedDate
        self.photoAccessStatus = photoAccessStatus
        self.onSave = onSave
        self.onDismiss = onDismiss

        // ViewModel 초기화
        _viewModel = State(
            initialValue: JourneyAddViewModel(existingJourney: existingJourney)
        )
    }

    var body: some View {
        // MARK: - 키보드 대응 레이아웃 (GrowthMilestoneView 패턴)
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                CustomNavigationBar(
                    title: viewModel.navigationTitle.isEmpty
                        ? selectedDate.yyyyMMdd : viewModel.navigationTitle,
                    leading: {
                        Button(action: {
                            endTextEditing()  // 키보드 내린 후 닫기
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                        }
                    }
                )
                .padding(.horizontal, 20)

                // MARK: - Limited Access 안내 배너
                if photoAccessStatus == .limited {
                    LimitedAccessBanner(
                        onSettingsTap: {
                            PhotoLibraryPermissionHelper.openSettings()
                        }
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }

                ScrollView {
                    VStack(spacing: 20) {
                        photoSection
                            .padding(.horizontal, 20)
                            .padding(.top, 8)

                        // 메모 영역
                        VStack(alignment: .leading, spacing: 8) {
                            Text("여정 메모")
                                .labelTextStyle()

                            TextField(
                                "아이와 함께한 소중한 여정 메모를 입력 해주세요",
                                text: $viewModel.memo,
                                axis: .vertical
                            )
                            .focused($isMemoFocused)  // 키보드 포커스 관리
                            .padding(16)
                            .frame(width: 353, height: 100, alignment: .top)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.brand40, lineWidth: 2)
                            )
                        }
                        .padding(.horizontal, 20)

                        Spacer()

                        // MARK: - 저장 버튼 (ScrollView 내부)
                        Button("저장") {
                            guard let image = viewModel.selectedImage else {
                                return
                            }

                            endTextEditing()  // 키보드 내림

                            // 리사이즈 로직 제거: JourneyViewModel(부모)에서 수행하므로 여기선 원본 전달
                            let latitude =
                                viewModel.extractedLocation?.coordinate.latitude
                                ?? 0.0
                            let longitude =
                                viewModel.extractedLocation?.coordinate
                                .longitude ?? 0.0

                            onSave(image, viewModel.memo, latitude, longitude)
                            dismiss()
                        }
                        .buttonStyle(
                            viewModel.isSaveDisabled
                                ? .noneButton : .defaultButton
                        )
                        .frame(height: 56)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        .disabled(viewModel.isSaveDisabled)
                    }
                    .padding(.bottom, 44)  // 하단 여백
                }
                .scrollDismissesKeyboard(.interactively)  // 스크롤 시 키보드 내림
            }
        }
        .ignoresSafeArea(edges: .top)
        .onTapGesture {
            endTextEditing()  // 빈 영역 탭 시 키보드 내림 (팀 extension 사용)
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

    // MARK: - Grow 스타일 사진 카드
    private var photoSection: some View {
        ZStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .transition(.opacity.combined(with: .scale))
            } else {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.brand40.opacity(0.4), lineWidth: 1.5)
                    )
                    .overlay(
                        VStack(spacing: 10) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 36, weight: .medium))
                                .foregroundColor(Color.brand40)
                            Text("아이와 함께한 소중한 여정 사진을 등록 해주세요")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    )
                    .frame(height: 265)  // 플레이스홀더만 고정 높이
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring) {
                showImagePicker = true
            }
        }
        .animation(.spring, value: viewModel.selectedImage)
    }
}

// MARK: - Limited Access 안내 배너

struct LimitedAccessBanner: View {
    let onSettingsTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)

            VStack(alignment: .leading, spacing: 4) {
                Text("위치 정보를 사용할 수 없습니다. 맵 위에는 보이지 않아요.")
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(2)
            }

            Spacer()

            Button("설정") {
                onSettingsTap()
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.blue)
        }
        .padding(12)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    JourneyAddView(
        selectedDate: Date(),
        photoAccessStatus: .authorized,
        onSave: { _, _, _, _ in },
        onDismiss: {}
    )
}
