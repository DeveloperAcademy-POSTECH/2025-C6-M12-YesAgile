//
//  JourneyListView.swift
//  babyMoa
//
//  Created by pherd on 11/11/25.
//
import SwiftUI

struct JourneyListView: View {
    @State var viewModel: JourneyListViewModel
    let onAddJourney: () -> Void
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var editingJourney: Journey? = nil  // 편집할 여정
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                title: viewModel.date.yyyyMMdd,
                leading: {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
            )
            .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.journies) { journey in
                        JourneyCard(
                            journey: journey,
                            onDelete: {
                                Task {
                                    let success = await viewModel.deleteJourney(journey)
                                    // 여정이 하나도 없으면 화면 닫기
                                    if success && viewModel.journies.isEmpty {
                                        onDismiss()
                                    }
                                }
                            }
                        )
                        .onTapGesture {
                            editingJourney = journey
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
            
            // 여정 추가 버튼
            Button("여정 추가") {
                onAddJourney()
            }
            .buttonStyle(
                AppButtonStyle(
                    backgroundColor: Color("BrandMain"),
                    foregroundColor: .white,
                    pressedBackgroundColor: Color("BrandMain").opacity(0.8)
                )
            )
            .frame(height: 56)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(Color.background)
        .ignoresSafeArea()
        .fullScreenCover(item: $editingJourney) { journey in
            JourneyAddView(
                selectedDate: journey.date,
                photoAccessStatus: PhotoLibraryPermissionHelper.checkAuthorizationStatus(),
                existingJourney: journey,
                onSave: { image, memo, lat, lon in
                    Task {
                        let success = await viewModel.updateJourney(
                            journey: journey,
                            image: image,
                            memo: memo,
                            latitude: lat,
                            longitude: lon
                        )
                        if success {
                            editingJourney = nil
                        }
                    }
                },
                onDismiss: {
                    editingJourney = nil
                }
            )
        }
    }
}

// MARK: - Journey Card

struct JourneyCard: View {
    let journey: Journey
    let onDelete: () -> Void
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 12) {
                // 사진 영역 (journeyImage는 non-optional)
                Image(uiImage: journey.journeyImage)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width - 40,
                        height: 300
                    )  // 명시적 크기 지정
                    .clipped()  // 넘치는 부분 강제로 자르기
                    .cornerRadius(16)
                
                // 메모 텍스트
                Text(journey.memo)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
            .background(
                Color.background
                    .ignoresSafeArea(edges: .bottom)  // 하단만 확장해 여백 없이 표시
            )
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            
            // 삭제 버튼 (우측 상단)
            Button(action: {
                showDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                    .frame(width: 36, height: 36)
                    .background(
                        Color(red: 243 / 255, green: 243 / 255, blue: 243 / 255)
                            .opacity(0.8)
                    )
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
            .padding(12)
        }
        .alert("아이와 함께한 소중한 추억", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) {}
            Button("삭제", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("추억을 삭제 하시겠습니까?")
        }
    }
}

// MARK: - Preview

#Preview {
    JourneyListView(
        viewModel: JourneyListViewModel(
            date: Date(),
            journies: Journey.mockData,
            parentVM: JourneyViewModel()
        ),
        onAddJourney: {},
        onDismiss: {}
    )
}
