//
//  JourneyListView.swift
//  babyMoa
//
//  Created by pherd on 11/11/25.
import SwiftUI

struct JourneyListView: View {
    let coordinator: BabyMoaCoordinator
    let selectedDate: Date
    let journies: [Journey]

    var body: some View {
        VStack(spacing: 0) {
            // ✅ CustomNavigationBar 추가 (Milestone 방식)
            CustomNavigationBar(
                title: formattedDate,
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
                    ForEach(journies, id: \.journeyId) { journey in
                        JourneyCard(
                            journey: journey,
                            onDelete: {
                                print("삭제: \(journey.journeyId)")
                                // TODO: JourneyViewModel.removeJourney() 호출
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }

            Spacer()

            // 여정 추가 버튼
            Button(action: {
                coordinator.push(path: .journeyAdd(date: selectedDate))
            }) {
                Text("여정 추가")
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
    }

    // MARK: - Helpers

    /// 날짜를 "yyyy.MM.dd" 형식으로 변환
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: selectedDate)
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
                if let image = journey.journeyImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 450)
                        .clipped()
                        .cornerRadius(16)
                } else {
                    // 이미지 없을 때 placeholder
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 450)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                        )
                }

                // 메모 텍스트
                Text(journey.memo)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
            .background(Color.background)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)

            // 삭제 버튼 (우측 상단)
            Button(action: {
                showDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 1.0, green: 0.3, blue: 0.2))
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
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
        coordinator: BabyMoaCoordinator(),
        selectedDate: Date(),
        journies: Journey.mockData
    )
}
