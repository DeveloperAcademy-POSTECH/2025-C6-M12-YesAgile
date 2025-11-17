//
//  JourneyAddView.swift
//  BabyMoaJourney
//
//  Created by pherd on 11/7/25.
//

import PhotosUI
import SwiftUI

struct JourneyAddView: View {
    let coordinator: BabyMoaCoordinator
    let selectedDate: Date
    /// 저장 콜백: 부모(JourneyView)가 JourneyViewModel을 통해 저장 처리
    ///   - image: 사용자가 선택한 사진 (nil 가능?)
    ///   - memo: 사용자가 입력한 메모
    let onSave: (UIImage?, String) -> Void // UIImage 옵셔널 수정 예정 저니뷰모델에게?
    // 부모가 넘겨주는 ‘저장할 때 실행할 함수’를 저장해두는 프로퍼티
    /// 선택된 이미지 ,메모, 사진선택 UI 표시 여부,PhotosPicker에서 선택한 항목
    @State private var selectedImage: UIImage?
    @State private var memo: String = ""
    @State private var showImagePicker = false
    @State private var pickedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                title: selectedDate.yyyyMMdd,
                leading: {
                    Button(action: {
                        coordinator.pop()
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
                // 1. 부모에게 데이터 전달 (콜백 실행)
                onSave(selectedImage, memo)
                // Todo 저니뷰모델에서
                // 1. API로 각월에 대해 불러와 Journey 리스트를 만들고
                //  2. 캘린더뷰모델과 맵뷰모델에 1. 에서만든 Journey 리스트를 공유
                //  Journey 추가할때는 캘린더뷰모델에서 호출, API "200"code오면 추가적인 조회 api 호출 없이 로컬 배열에 추가
                // 3. 화면 닫기
                coordinator.pop()
            }
            .buttonStyle(.defaultButton)
            .frame(height: 56)
            .padding(.horizontal, 20)
            .padding(.bottom, 227)
        }
        .background(Color.background)
        .ignoresSafeArea()
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
