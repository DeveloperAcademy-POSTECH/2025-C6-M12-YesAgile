//
//  JourneyListView.swift
//  babyMoa
//
//  Created by pherd on 11/11/25.
//  Refactored on 11/22/25
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
            // 네비게이션 바
            CustomNavigationBar(
                title: viewModel.date.yyyyMMddKorean,
                leading: {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.brand50)
                    }
                },
                trailing: { EmptyView() },
                paddingTop: 10
            )
            .background(Color.background)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.journeys) { journey in
                        JourneyCard(
                            journey: journey,
                            onDelete: {
                                Task {
                                    let success = await viewModel.deleteJourney(journey)
                                    if success && viewModel.journeys.isEmpty {
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
            Button {
                onAddJourney()
            } label: {
                Text("여정 추가")
            }
            .buttonStyle(.defaultButton) // brand50 사용
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(item: $editingJourney) { journey in
            JourneyAddView(
                selectedDate: journey.date,
                existingJourney: journey,
                onSave: { (image: UIImage, memo: String, lat: Double, lon: Double) -> Void in
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
                // 사진 영역
                Group {
//                    if let localImage = journey.journeyImage {
//                        // 1. 로컬 이미지가 있으면 우선 표시 (업로드 직후)
//                        Image(uiImage: localImage)
//                            .resizable()
//                            .scaledToFill()
//                            .overlay(
//                                // 임시 상태일 때 로딩 오버레이
//                                Group {
//                                    if journey.isTemporary {
//                                        ZStack {
//                                            Color.black.opacity(0.3)
//                                            ProgressView()
//                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                                        }
//                                    }
//                                }
//                            )
//                    } else {
                        // 2. 없으면 URL에서 Lazy Loading
                        CachedAsyncImage(urlString: journey.imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ZStack {
                                    Color.gray.opacity(0.1)
                                    ProgressView()
                                }
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                ZStack {
                                    Color.gray.opacity(0.1)
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                }
                            @unknown default:
                                EmptyView()
                            }
                        }
//                    }
                }
                .frame(
                    width: UIScreen.main.bounds.width - 40,
                    height: 300
                )
                .clipped()
                .cornerRadius(16)

                // 메모 텍스트
                Text(journey.memo)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)

            // 삭제 버튼
            Button(action: {
                showDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(12)
        }
        .alert("아이와 함께한 소중한 여정", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) {}
            Button("삭제", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("여정을 삭제 하시겠습니까?")
        }
    }
}

// MARK: - Preview

#Preview {
    JourneyListView(
        viewModel: JourneyListViewModel(
            date: Date(),
            journeys: Journey.mockData
        ),
        onAddJourney: {},
        onDismiss: {}
    )
}
