//
//  JourneyCalendarView.swift
//  BabyMoa
//
//  Created by pherd on 11/6/25.
//

import SwiftUI

// MARK: - JourneyCalendarView

struct JourneyCalendarView: View {
    @State private var viewModel = JourneyCalendarViewModel()
        
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 7
    )
    
    // MARK: - Shared Helper for Weekday Colors (Moved to file scope)
    private func getWeekdayColor(for weekday: Int) -> Color {
        if weekday == 1 { return .red } // Sunday
        if weekday == 7 { return .blue } // Saturday
        return .black
    }

    var body: some View {
    
        VStack(spacing: 0) {
            //MARK: - Header
            ZStack{
                HStack{
                    Button(action: {
                        viewModel.previousMonthTapped()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.brandLight)

                    })
                    Spacer()
                    Button(action: {
                        viewModel.nextMonthTapped()
                    }, label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.brandLight)
                    })
                }
                HStack{
                    Spacer()
                    Text(viewModel.monthYearString)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.font)
                    Spacer()
                }
            }
            .padding(.bottom, 10)

            DaysOfWeekHeader()
                .padding(.bottom, 10)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.monthDates, id: \.self) { date in
                    DateCellView(
                        date: date,
                        isCurrentMonth: viewModel.isInCurrentMonth(date),
                        isSelected: viewModel.isSelected(date),
                        textColor: getWeekdayColor(for: Calendar.current.component(.weekday, from: date))
                    )
                    .onTapGesture {
                        viewModel.dateTapped(date)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
    }
    
   
}


// MARK: - Days of Week Header

private struct DaysOfWeekHeader: View {
    let days = ["일", "월", "화", "수", "목", "금", "토"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7) { index in
                Text(days[index])
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(getWeekdayColor(for: index + 1)) // Use shared helper
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - Date Cell (Purely for date display)

private struct DateCellView: View {
    let date: Date
    let isCurrentMonth: Bool
    let isSelected: Bool
    let textColor: Color // Now directly passed

    var body: some View {
        ZStack {
            if isSelected {
                Circle().fill(Color.brandSecondary.opacity(0.1))
            }
            
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                .foregroundColor(.gray.opacity(0.3))

            Text("\(day)")
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundColor(textColor)
        }
        .frame(width: 40, height: 40)
        .opacity(isCurrentMonth ? 1.0 : 0.3)
    }

    private var day: Int {
        Calendar.current.component(.day, from: date)
    }
}

// MARK: - Weekday Color Helper (Moved to file scope)
private func getWeekdayColor(for weekday: Int) -> Color {
    if weekday == 1 { return .red } // Sunday
    if weekday == 7 { return .blue } // Saturday
    return .black
}

#Preview {
    JourneyCalendarView()
}
