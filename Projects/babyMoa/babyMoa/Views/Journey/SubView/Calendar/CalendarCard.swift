//
//  CalendarCard.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//

import SwiftUI

// MARK: - Data & Actions

struct CalendarCardData {
    let currentMonth: Date
    let monthDates: [Date]
    let selectedDate: Date
    let journies: [Journey]
}

struct CalendarCardActions {
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    let onDateTap: (Date) -> Void
    let isInCurrentMonth: (Date) -> Bool
    let isSelected: (Date) -> Bool
}

// MARK: - CalendarCard

struct CalendarCard: View {
    let data: CalendarCardData
    let actions: CalendarCardActions

    var body: some View {
        VStack(spacing: 0) {
            // 월 네비게이션
            // 여기서 쓰는 value들 직접 뷰모델 받아서 쓰지말고, 프로퍼티로 선언해서 뷰에서 주입할 수 있도록!
            MonthNavigationView(
                currentMonth: data.currentMonth,
                onPrevious: actions.onPreviousMonth,
                onNext: actions.onNextMonth
            )
            .padding(.bottom, 20)

            // 요일 헤더
            DaysOfWeekHeader()
                .padding(.bottom, 10)

            // 날짜 그리드
            CalendarGrid(
                data: data,
                actions: actions
            )
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
}

// MARK: - Month Navigation

struct MonthNavigationView: View {
    let currentMonth: Date
    let onPrevious: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack {
            // 이전 월 버튼
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.orange)
            }

            Spacer()

            // 년월 표시
            Text(monthYearString)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            // 다음 월 버튼
            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.orange)
            }
        }
    }

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: currentMonth)
    }
}

// MARK: - Days of Week Header

struct DaysOfWeekHeader: View {
    let days = ["일", "월", "화", "수", "목", "금", "토"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7) { index in
                Text(days[index])
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(dayColor(for: index))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func dayColor(for index: Int) -> Color {
        if index == 0 { return .red }  // 일요일
        if index == 6 { return .blue }  // 토요일
        return .black
    }
}

// MARK: - Calendar Grid

/// 날짜 그리드
struct CalendarGrid: View {
    let data: CalendarCardData
    let actions: CalendarCardActions

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 7
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(data.monthDates, id: \.self) { date in
                let dateJournies = data.journies.filter { journey in
                    journey.date.yyyyMMdd == date.yyyyMMdd
                }
                DateCellView(
                    date: date,
                    isCurrentMonth: actions.isInCurrentMonth(date),
                    journies: dateJournies,
                    isSelected: actions.isSelected(date)
                )
                .onTapGesture {
                    actions.onDateTap(date)
                }
            }
        }
    }
}

// MARK: - Date Cell

struct DateCellView: View {
    let date: Date
    let isCurrentMonth: Bool
    let journies: [Journey]
    let isSelected: Bool  // 선택 상태

    var body: some View {
        ZStack {
            // 선택된 날짜 배경
            if isSelected {
                Circle()
                    .fill(Color.orange)
            }

            // 점선 원 테두리
            Circle()
                .strokeBorder(
                    style: StrokeStyle(lineWidth: 1, dash: [2, 2])
                )
                .foregroundColor(.gray.opacity(0.3))

            // 이미지 썸네일 + 날짜 숫자
            ZStack {
                // 여정 이미지 (있으면 표시)
                // journeyImage는 non-optional
                if let first = journies.first {
                    Image(uiImage: first.journeyImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
                // 날짜 숫자 (항상 표시, 이미지 위에 오버레이)
                Text("\(day)")
                    .font(
                        .system(size: 16, weight: isSelected ? .bold : .regular)
                    )
                    .foregroundColor(journies.first?.journeyImage != nil ? .white : textColor)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            .frame(width: 40, height: 40)
        }
        .frame(height: 44)
        .opacity(isCurrentMonth ? 1.0 : 0.3)
    }

    private var day: Int {
        Calendar.current.component(.day, from: date)
    }

    private var textColor: Color {
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 { return .red }  // 일요일
        if weekday == 7 { return .blue }  // 토요일
        return .black
    }
}

#Preview {
    PreviewWrapper()
}

// MARK: - Preview Helper

private struct PreviewWrapper: View {
    @State private var viewModel: CalendarCardViewModel
    let coordinator = BabyMoaCoordinator()
    
    init() {
     
        let journeyVM = JourneyViewModel()
        journeyVM.journies = Journey.mockData
        
        _viewModel = State(initialValue: CalendarCardViewModel(journeyViewModel: journeyVM))
    }
    
    var body: some View {
        CalendarCard(
            data: CalendarCardData(
                currentMonth: viewModel.currentMonth,
                monthDates: viewModel.monthDates,
                selectedDate: viewModel.selectedDate,
                journies: viewModel.journies
            ),
            actions: CalendarCardActions(
                onPreviousMonth: { viewModel.previousMonthTapped() },
                onNextMonth: { viewModel.nextMonthTapped() },
                onDateTap: { date in
                    _ = viewModel.dateTapped(date)
                },
                isInCurrentMonth: { date in
                    viewModel.isInCurrentMonth(date)
                },
                isSelected: { date in
                    viewModel.isSelected(date)
                }
            )
        )
    }
}
