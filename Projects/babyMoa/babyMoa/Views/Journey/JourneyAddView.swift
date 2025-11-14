//
//  JourneyAddView.swift
//  BabyMoaJourney
//
//  Created by pherd on 11/7/25.
//

import PhotosUI
import SwiftUI

struct JourneyAddView: View {
    // MARK: - Properties

    /// Coordinator (Milestone 방식) - Navigation 경로에서 진입한 경우 사용
    let coordinator: BabyMoaCoordinator?

    /// 선택된 날짜
    let selectedDate: Date

    /// 저장 콜백: 부모(JourneyView)가 JourneyViewModel을 통해 저장 처리
    /// - Parameters:
    ///   - image: 사용자가 선택한 사진 (nil 가능?)
    ///   - memo: 사용자가 입력한 메모
    let onSave: (UIImage?, String) -> Void
    // 부모가 넘겨주는 ‘저장할 때 실행할 함수’를 저장해두는 프로퍼티

    // MARK: - State (현재 화면 상태 - 앱 종료 시 사라짐)

    /// 선택된 이미지 ,메모, 사진선택 UI 표시 여부,PhotosPicker에서 선택한 항목
    /// 화면 즉시반영하게 스테이트로
    @State private var selectedImage: UIImage?
    @State private var memo: String = ""
    @State private var showImagePicker = false
    @State private var pickedItem: PhotosPickerItem? = nil

    /// Sheet/FullScreenCover 해제용
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // ✅ CustomNavigationBar 추가 타이틀, 꺽쇄
            CustomNavigationBar(
                title: formattedDate,
                leading: {
                    Button(action: {
                        if let coordinator {
                            coordinator.pop()
                        } else {
                            dismiss()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
            )
            .padding(.horizontal, 20)

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
                    .padding(.horizontal, 20)

                    // 메모 영역
                    VStack(alignment: .leading, spacing: 8) {
                        Text("여정 메모")
                            .font(.system(size: 16, weight: .semibold))

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
                                .stroke(Color.brand40, lineWidth: 2)  //BrandLight 이 없어서 40 대체
                        )
                    }
                    .padding(.horizontal, 20)
                }

            }

            Spacer()

            // 저장 버튼
            Button(action: {
                // 1. 부모에게 데이터 전달 (콜백 실행)
                onSave(selectedImage, memo)
                // 2. 화면 닫기
                if let coordinator {
                    coordinator.pop()
                } else {
                    dismiss()
                }
            }) {
                Text("저장")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.brandMain)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 227)
        }
        .background(Color.background)
        .ignoresSafeArea() //흰화면 대
        .photosPicker(
            isPresented: $showImagePicker,
            selection: $pickedItem,
            matching: .images
        )
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

    // MARK: - Computed Properties

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: selectedDate)
    }
}

#Preview {
    JourneyAddView(
        coordinator: BabyMoaCoordinator(),
        selectedDate: Date(),
        onSave: { image, memo in
            print("Preview: 저장 - \(memo)")
        }
    )
}
