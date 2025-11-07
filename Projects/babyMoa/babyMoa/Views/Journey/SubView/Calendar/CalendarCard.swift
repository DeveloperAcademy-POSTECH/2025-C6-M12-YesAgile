//
//  CalendarCard.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//

import SwiftUI

struct CalendarCard: View {
    @Binding var viewModel: CalendarViewModel  //  @Binding
    let journies: [Journey]
    
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
            
            // 날짜 그리드
            CalendarGrid(
                viewModel: $viewModel,  // @Binding 전달
                journies: journies
            )
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
    
    // moveMonth 함수 제거 (ViewModel로 이동)
}

// MARK: - Month Navigation

struct MonthNavigationView: View {
    let currentMonth: Date  //
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
                .font(.system(size: 20, weight: .bold))
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
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(dayColor(for: index))
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func dayColor(for index: Int) -> Color {
        if index == 0 { return .red }      // 일요일
        if index == 6 { return .blue }     // 토요일
        return .black
    }
}

// MARK: - Calendar Grid

/// 날짜 그리드 - 심플하게 ViewModel 데이터만 표시
struct CalendarGrid: View {
    @Binding var viewModel: CalendarViewModel  //  @Binding 사용
    let journies: [Journey]
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            //  직접 접근, Helper 함수 없음
            ForEach(viewModel.monthDates, id: \.self) { date in
                DateCellView(
                    date: date,
                    isCurrentMonth: viewModel.isInCurrentMonth(date),  // ViewModel 호출
                    hasJourney: viewModel.hasJourney(date, journies: journies),  // ViewModel 호출
                    isSelected: viewModel.isSelected(date)  // ViewModel 호출
                )
                .onTapGesture {
                    viewModel.dateTapped(date)  // ViewModel 호출
                }
            }
        }
    }
    
    // Helper 함수 없음! (ViewModel로 이동)
}

// MARK: - Date Cell

struct DateCellView: View {
    let date: Date
    let isCurrentMonth: Bool
    let hasJourney: Bool
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
                    style: StrokeStyle(lineWidth: 1, dash: [3, 3])
                )
                .foregroundColor(.gray.opacity(0.3))
            
            // 날짜 숫자
            Text("\(day)")
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))  // 선택 시 볼드
                .foregroundColor(textColor)
        }
        .frame(height: 50)
        .opacity(isCurrentMonth ? 1.0 : 0.3)
    }
    
    private var day: Int {
        Calendar.current.component(.day, from: date)
    }
    
    private var textColor: Color {
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 { return .red }      // 일요일
        if weekday == 7 { return .blue }     // 토요일
        return .black
    }
}

// MARK: - Preview

#Preview {
    let coordinator = BabyMoaCoordinator()
    let viewModel = CalendarViewModel(coordinator: coordinator)
    
    return VStack {
        CalendarCard(
            viewModel: .constant(viewModel),  // .constant() 사용
            journies: Journey.mockData
        )
        .padding(.horizontal, 20)
        Spacer()
    }
    .background(Color(.systemGroupedBackground))
}

