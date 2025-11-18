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
            .background(Color.white)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(journies, id: \.journeyId) { journey in
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
            .buttonStyle(.primaryButton)
            .frame(height: 56)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(
            Color(red: 0.95, green: 0.95, blue: 0.97)
                .ignoresSafeArea()  // ✅ 배경만 Safe Area 위로 확장 (콘텐츠는 안전하게 유지)
        )
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
                    .frame(height: 300)
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
        .background(
            Color.background
                .ignoresSafeArea(edges: .bottom) // 하단만 확장해 여백 없이 표시
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
        selectedDate: Date(),
        journies: Journey.mockData,
        onAddJourney: { },
        onDeleteJourney: { _ in },
        onDismiss: { }
    )
}
