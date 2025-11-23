//
//  JourneyCalendarView.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//  Refactored on 11/22/25
//

import SwiftUI

struct JourneyCalendarView: View {
    @Bindable var viewModel: JourneyCalendarViewModel
    let journeys: [Journey]
    let onDateSelected: (Date) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // 월 네비게이션
            MonthNavigationView(
                currentMonth: viewModel.currentMonth,
                onPrevious: { viewModel.previousMonthTapped() },
                onNext: { viewModel.nextMonthTapped() }
            )
            .padding(.bottom, 20)

            // 요일 헤더
            DaysOfWeekHeader()
                .padding(.bottom, 10)

            // 날짜 그리드
            CalendarGrid(
                viewModel: viewModel,
                journeys: journeys,
                onDateTap: { date in
                    viewModel.selectDate(date)
                    onDateSelected(date)
                }
            )
        }
        .padding(20)
        .frame(width: 354, height: 380)  // 캘린더 고정 크기 (패딩 포함)
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
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.orange)
            }

            Spacer()

            Text(monthYearString)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)

            Spacer()

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

struct CalendarGrid: View {
    let viewModel: JourneyCalendarViewModel
    let journeys: [Journey]
    let onDateTap: (Date) -> Void

    // .fixed(40) + spacing: 6으로 설정하여 354pt 프레임 안에 정확히 맞춤
    // 계산: 40 × 7 + 6 × 6 = 280 + 36 = 316pt (사용 가능: 314pt이므로 여유 2pt)
    private let columns = Array(repeating: GridItem(.fixed(40), spacing: 6), count: 7)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(viewModel.monthDates, id: \.self) { date in
                // 해당 날짜의 여정 필터링 (간단한 비교)
                // Date Extension이 없다면 Calendar로 비교해야 함.
                // 여기서는 안전하게 Calendar 비교 사용
                let dateJourneys = journeys.filter { journey in
                    Calendar.current.isDate(journey.date, inSameDayAs: date)
                }
                
                let isCurrentMonth = viewModel.isInCurrentMonth(date)
                
                DateCellView(
                    date: date,
                    isCurrentMonth: isCurrentMonth,
                    journeys: dateJourneys,
                    isSelected: viewModel.isSelected(date)
                )
                .onTapGesture {
                    if isCurrentMonth {
                        onDateTap(date)
                    }
                }
            }
        }
    }
}

// MARK: - Date Cell

struct DateCellView: View {
    let date: Date
    let isCurrentMonth: Bool
    let journeys: [Journey]
    let isSelected: Bool

    var body: some View {
        ZStack {
            // 선택된 날짜 배경
            if isSelected {
                Circle()
                    .fill(Color.orange.opacity(0.1)) // BrandSecondary 대체
            }

            // 점선 원 테두리
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                .foregroundColor(.gray.opacity(0.3))

            // 이미지 썸네일 + 날짜 숫자
            ZStack {
                if let first = journeys.first {
                    Group {
                        if let localImage = first.journeyImage {
                            Image(uiImage: localImage)
                                .resizable()
                                .scaledToFill()
                                .opacity(first.isTemporary ? 0.7 : 1.0) // 임시 상태면 약간 투명
                        } else {
                            CachedAsyncImage(urlString: first.imageUrl) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                case .failure:
                                    Color.gray.opacity(0.3)
                                case .empty:
                                    Color.gray.opacity(0.1)
                                @unknown default:
                                    Color.gray.opacity(0.1)
                                }
                            }
                        }
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                }

                Text("\(day)")
                    .font(.system(size: 13, weight: isSelected ? .bold : .regular))
                    .foregroundColor(journeys.first != nil ? .white : textColor)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            .frame(width: 36, height: 36)  // 40 → 36으로 축소
        }
        .frame(width: 40, height: 40)  // 셀 전체 크기 명시 (aspectRatio 대신 명확한 크기)
        .opacity(isCurrentMonth ? 1.0 : 0.3)
    }

    private var day: Int {
        Calendar.current.component(.day, from: date)
    }

    private var textColor: Color {
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 { return .red }
        if weekday == 7 { return .blue }
        return .black
    }
}

// MARK: - Preview

#Preview {
    JourneyCalendarView(
        viewModel: JourneyCalendarViewModel(),
        journeys: Journey.mockData,
        onDateSelected: { _ in }
    )
}

