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
    /// - Parameters:
    ///   - image: 선택한 사진 (필수)
    ///   - memo: 여정 메모
    ///   - latitude: 위도 (위치 정보 없으면 0.0)
    ///   - longitude: 경도 (위치 정보 없으면 0.0)
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

    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                title: selectedDate.yyyyMMdd,
                leading: {
                    Button(action: {
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
                    // 사진 영역
                    Button(action: { showImagePicker = true }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white)
                                )
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16)
                                    )
                            } else {
                                Text("아이와 함께한 소중한 여정 사진을 등록 해주세요")
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                        }
                        .frame(width: 353, height: 265)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)

                    // 메모 영역
                    VStack(alignment: .leading, spacing: 8) {
                        Text("여정 메모")
                            .labelTextStyle()

                        TextField(
                            "아이와 함께한 소중한 여정 메모를 입력 해주세요",
                            text: $memo,
                            axis: .vertical
                        )
                        .padding(16)
                        .frame(width: 353, height: 100, alignment: .top)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.brand40, lineWidth: 2)
                        )
                    }
                    .padding(.horizontal, 20)
                }

            }

            Spacer()

            // 저장 버튼
            Button("저장") {
                guard let image = selectedImage else {
                    return  // ✅ 사진 필수
                }

                // 위치 정보 (없으면 0.0)
                let latitude = extractedLocation?.coordinate.latitude ?? 0.0
                let longitude = extractedLocation?.coordinate.longitude ?? 0.0

                // 부모에게 데이터 전달
                onSave(image, memo, latitude, longitude)

                dismiss()
            }
            .buttonStyle(.defaultButton)
            .frame(height: 56)
            .padding(.horizontal, 20)
            .padding(.bottom, 227)
            .disabled(selectedImage == nil)  // ✅ 사진 없으면 비활성화
        }
        .background(Color.background)
        .ignoresSafeArea()
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
