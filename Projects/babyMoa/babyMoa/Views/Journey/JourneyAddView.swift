//
//  JourneyAddView.swift
//  BabyMoaJourney
//
//  Created by pherd on 11/7/25.
//

import SwiftUI

struct JourneyAddView: View {
    let coordinator: BabyMoaCoordinator  //
    let selectedDate: Date
    
    @State private var selectedImage: UIImage?
    @State private var memo: String = ""
    @State private var showImagePicker = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 날짜 헤더
            Text(formattedDate)
                .font(.system(size: 18, weight: .semibold))
                .padding(.vertical, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    // 사진 영역
                    Button(action: { showImagePicker = true }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.blue, lineWidth: 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white)
                                )
                            
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            } else {
                                Text("아이와 함께한 소중한 추억 사진을 등록 해주세요")
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                        }
                        .frame(height: 450)
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
                        .frame(minHeight: 150, alignment: .top)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
            
            Spacer()
            
            // 저장 버튼
            Button(action: {
                // TODO: ViewModel에서 저장 로직 처리
                coordinator.pop()  //
            }) {
                Text("저장")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 1.0, green: 0.3, blue: 0.2))
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
        .sheet(isPresented: $showImagePicker) {
            // TODO: ImagePicker
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
        selectedDate: Date()
    )
}
