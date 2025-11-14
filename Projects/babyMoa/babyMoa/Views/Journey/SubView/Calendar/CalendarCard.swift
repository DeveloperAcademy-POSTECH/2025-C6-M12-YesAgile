//
//  CalendarCard.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//

import SwiftUI

struct CalendarCard: View {
    var viewModel: CalendarCardViewModel

    // MARK: - Binding (부모로부터 받음)

    /// 여정 추가 Sheet 표시 여부
    @Binding var showAddJourney: Bool

    /// 선택된 날짜 (여정 추가용)
    @Binding var selectedDateForAdd: Date?

    var body: some View {
        VStack(spacing: 0) {
            // 월 네비게이션
            MonthNavigationView(
                currentMonth: viewModel.currentMonth,  // ViewModel 데이터
                onPrevious: {
                    viewModel.previousMonthTapped()  // ViewModel 호출
                },
                onNext: {
                    viewModel.nextMonthTapped()  // ViewModel 호출
                }
            )
            .padding(.bottom, 20)

            // 요일 헤더
            DaysOfWeekHeader()
                .padding(.bottom, 10)

            // 날짜 그리드 (Binding 전달)
            CalendarGrid(
                viewModel: viewModel,
                showAddJourney: $showAddJourney,
                selectedDateForAdd: $selectedDateForAdd
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

/// 날짜 그리드 - 심플하게 ViewModel 데이터만 표시
struct CalendarGrid: View {
    var viewModel: CalendarCardViewModel

    // MARK: - Binding (CalendarCard로부터 받음)

    /// 여정 추가 Sheet 표시 여부
    @Binding var showAddJourney: Bool

    /// 선택된 날짜 (여정 추가용)
    @Binding var selectedDateForAdd: Date?

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 7
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(viewModel.monthDates, id: \.self) { date in
                let dateJournies = viewModel.journies.filter({
                    $0.date.yyyyMMdd == date.yyyyMMdd
                })
                DateCellView(
                    date: date,
                    isCurrentMonth: viewModel.isInCurrentMonth(date),
                    journies: dateJournies,
                    isSelected: viewModel.isSelected(date)
                )
                .onTapGesture {
                    // Binding 전달
                    viewModel.dateTapped(
                        date,
                        showAddJourney: $showAddJourney,
                        selectedDateForAdd: $selectedDateForAdd
                    )
                }
            }
        }
    }
}

// MARK: - Date Cell

struct DateCellView: View {
    let date: Date
    let isCurrentMonth: Bool
    let journies: [Journey]  //ourney 인스턴스를 “데려오는 코드”가 아니야.그냥 “나는 이런 타입의 값을 받을 거야”라고 타입만 선언 이건 저장 프로퍼티임
    let isSelected: Bool  // 선택 상태 추가

    var body: some View {
        ZStack {
            // 선택된 날짜 배경
            if isSelected {
                Circle()
                    .fill(Color.orange.opacity(0.2))
            }

            // 점선 원 테두리
            Circle()
                .strokeBorder(
                    style: StrokeStyle(lineWidth: 1, dash: [2, 2])
                )
                .foregroundColor(.gray.opacity(0.3))

            // 날짜 숫자
            Text("\(day)")
                .font(
                    .system(size: 16, weight: isSelected ? .bold : .regular)
                )  // 선택 시 볼드
                .foregroundColor(textColor)

            // TODO: 삭제 필요, journey 가 잘들어왔나 테스트하기 위한 코드 (Ted 맘대로 추가한 거)

            if let first = journies.first,
                let uiImage = first.journeyImage
            {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(
                            style: StrokeStyle(lineWidth: 1, dash: [4])
                        )
                        .opacity(0.3)  // 점선 테두리
                    }
            } else {
                // 이미지 없을 때 자리(선택)
                Spacer(minLength: 28)
            }
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

private struct PreviewWrapper: View {
    @State private var showAdd = false
    @State private var date: Date? = nil

    var body: some View {
        let coordinator = BabyMoaCoordinator()
        let journeyVM = JourneyViewModel(coordinator: coordinator)
        journeyVM.journies = Journey.mockData  // ✨ Mock 데이터 추가!

        return CalendarCard(
            viewModel: CalendarCardViewModel(
                coordinator: coordinator,
                journeyViewModel: journeyVM
            ),
            showAddJourney: $showAdd,
            selectedDateForAdd: $date
        )
    }
}
