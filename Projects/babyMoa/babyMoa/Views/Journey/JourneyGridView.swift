//
//  JourneyGridView.swift
//  BabyMoa
//
//  Created by pherd on 11/8/25.
//

import SwiftUI

/// 같은 날짜에 여러 여정이 있을 때 그리드로 표시
/// - Note: MapCard 마커 클릭 시 2개 이상인 경우 이동
struct JourneyGridView: View {
    let selectedDate: Date
    let journies: [Journey]  // 이미 최신순 정렬됨
    let onJourneyTap: (Journey) -> Void
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    init(selectedDate: Date, journies: [Journey], onJourneyTap: @escaping (Journey) -> Void, onDismiss: @escaping () -> Void) {
        self.selectedDate = selectedDate
        self.journies = journies
        self.onJourneyTap = onJourneyTap
        self.onDismiss = onDismiss
    }
    
    // 3열 그리드
    private let columns = [
        GridItem(.flexible(), spacing: 26),
        GridItem(.flexible(), spacing: 26),
        GridItem(.flexible(), spacing: 26),
    ]

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
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(journies, id: \.journeyId) { journey in
                        Button {
                            // 사진 클릭 → JourneyListView (상세)
                            onJourneyTap(journey)
                        } label: {
                            Image(uiImage: journey.journeyImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color.background)
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationStack {
        JourneyGridView(
            selectedDate: Date(),
            journies: Journey.mockData,
            onJourneyTap: { _ in },
            onDismiss: { }
        )
    }
}
