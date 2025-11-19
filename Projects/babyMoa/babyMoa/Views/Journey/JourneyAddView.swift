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
    let photoAccessStatus: PHAuthorizationStatus  // ✅ 추가: 사진 라이브러리 권한 상태
    /// 저장 콜백: 부모(JourneyView)가 JourneyViewModel을 통해 저장 처리
    let onSave: (UIImage, String, Double, Double) -> Void
    let onDismiss: () -> Void

    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    @State private var selectedImage: UIImage?
    @State private var memo: String = ""
    @State private var showImagePicker = false
    @State private var pickedItem: PhotosPickerItem? = nil
    @State private var extractedLocation: CLLocation?  // ✅ 위치 정보
    @State private var showLocationAlert = false  // ✅ 위치 없음 알림
    @FocusState private var isMemoFocused: Bool  // 키보드 포커스 관리

    var body: some View {
        // MARK: - 키보드 대응 레이아웃 (GrowthMilestoneView 패턴)
        // ZStack + ScrollView 구조로 키보드가 올라올 때 저장 버튼이 자동으로 위로 밀림? 근데 왜 적용이 안되냐..
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomNavigationBar(
                    title: selectedDate.yyyyMMdd,
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
                                text: $memo,
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
                        // 키보드가 올라오면 자동으로 위로 밀림
                        Button("저장") {
                            guard let image = selectedImage else {
                                return
                            }

                            endTextEditing()  // 키보드 내림
                            
                            let resizedImage = ImageManager.shared.resizeImage(image, maxSize: 1024)
                            let latitude = extractedLocation?.coordinate.latitude ?? 0.0
                            let longitude = extractedLocation?.coordinate.longitude ?? 0.0

                            onSave(resizedImage, memo, latitude, longitude)
                            dismiss()
                        }
                        .buttonStyle(.defaultButton)
                        .frame(height: 56)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        .disabled(selectedImage == nil)
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
            // MARK: - iCloud Photo Library 에러 방지
            // preferredItemEncoding: .current
            // - 디바이스에 이미 저장된 버전 사용 (즉시 로딩)
            // - iCloud에서 원본 다운로드하지 않음 (에러 방지)
            // - 품질: 1080p~2K (서버 저장용으로 충분)
            // - 참고: .compatible은 원본 다운로드 (느림, 에러 가능)
            preferredItemEncoding: .current
        )
        .onChange(of: pickedItem) { _, newValue in
            guard let newValue else { return }

            Task { @MainActor in
                // 1. 이미지 로드
                guard
                    let data = try? await newValue.loadTransferable(
                        type: Data.self
                    ),
                    let uiImage = UIImage(data: data)
                else {
                    selectedImage = nil
                    extractedLocation = nil
                    return
                }

                selectedImage = uiImage

                // 2. EXIF에서 위치 정보 추출
                // Instagram, WhatsApp 등 대부분의 앱이 사용하는 방식
                if let location = ImageEXIFHelper.extractLocation(from: data) {
                    extractedLocation = location
                }
                // 3. 위치 정보 없음 (스크린샷, 위치 태그 비활성화 등)
                else {
                    extractedLocation = nil
                    showLocationAlert = true
                }
            }
        }
        .alert("위치 정보 없음", isPresented: $showLocationAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("사진에 위치 정보가 없어서 지도 위에 보이지 않습니다.")
        }
    }

    // MARK: - Grow 스타일 사진 카드
    private var photoSection: some View {
        ZStack {
            if let image = selectedImage {
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
        .animation(.spring, value: selectedImage)
    }
}

// MARK: - Limited Access 안내 배너

/// Limited Access 상태일 때 표시되는 안내 배너
/// - 사용자에게 위치 정보 사용 불가를 알림
/// - 설정 앱으로 이동하여 권한 변경 유도
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
