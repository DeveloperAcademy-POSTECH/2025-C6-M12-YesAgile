//
//  JourneyListView.swift
//  babyMoa
//
//  Created by pherd on 11/11/25.
import SwiftUI

struct JourneyListView: View {
    let selectedDate: Date
    let journies: [Journey]
    let onAddJourney: () -> Void
    let onDeleteJourney: (Journey) -> Void
    let onDismiss: () -> Void

    @Environment(\.dismiss) private var dismiss

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

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(journies) { journey in
                        JourneyCard(
                            journey: journey,
                            onDelete: {
                                onDeleteJourney(journey)
                            }
                        )
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
        .background(Color.background)  // JourneyAddView와 동일한 배경 컬러
        .ignoresSafeArea()  // 상/하단 모두 Safe Area까지 확장
    }
}

// MARK: - Journey Card Todo : 업데이트 및 삭제구현..

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
                    .frame(width: 24, height: 24)
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
        selectedDate: Date(),
        journies: Journey.mockData,
        onAddJourney: {},
        onDeleteJourney: { _ in },
        onDismiss: {}
    )
}
