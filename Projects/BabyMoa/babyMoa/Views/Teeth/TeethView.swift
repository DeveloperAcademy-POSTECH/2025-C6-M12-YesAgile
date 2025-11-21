//
//  TeethView.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  치아 상세 뷰 - 위아래 10개씩 표시
//  컴포넌트화로 코드 간결화

import SwiftUI

struct TeethView: View {
    @State var viewModel: TeethViewModel
    @State private var selectedTeethId: Int? = nil
    @State private var isDatePickerPresented = false
    @State private var selectedDate = Date()
    @State private var isDeleteAlertPresented = false
    @State private var teethIdToDelete: Int? = nil
    
    init(coordinator: BabyMoaCoordinator, teethList: [TeethData]) {
        viewModel = TeethViewModel(
            coordinator: coordinator,
            teethList: teethList
        )
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomNavigationBar(title: "치아", leading: {
                    Button(action: {
                        viewModel.coordinator.pop()
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                })
                .padding(.bottom, 30)
                
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.memoryLightPink)
                    .frame(height: 100)
                    .overlay(
                        VStack {
                            // 윗줄(10개) + 아랫줄(10개)
                            ForEach(0..<2, id: \.self) { rowIdx in
                                LineTeethView(
                                    viewModel: $viewModel,
                                    selectedTeethId: $selectedTeethId,
                                    isDatePickerPresented: $isDatePickerPresented,
                                    isDeleteAlertPresented: $isDeleteAlertPresented,
                                    teethIdToDelete: $teethIdToDelete,
                                    rowIdx: rowIdx
                                )
                                if rowIdx == 0 {
                                    Spacer()
                                }
                            }
                        }
                    )
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)

                ScrollView(.vertical, showsIndicators: false) {
                    if !viewModel.sortedEruptedTeethList.isEmpty {
                        EruptedTeethListView(viewModel: $viewModel)
                            .padding(.top, 25)
                    } else {
                        TeethEmptyStateView()
                    }
                    Spacer()
                }
            }
            .backgroundPadding(.horizontal)

            if isDatePickerPresented {
                CustomDatePicker(
                    selectedDate: $selectedDate,
                    isPresented: $isDatePickerPresented,
                    onConfirm: { newDate in
                        if let teethId = selectedTeethId {
                            Task {
                                let dateStr = DateFormatter.yyyyDashMMDashdd.string(from: newDate)
                                await viewModel.setTeethStatus(
                                    teethId: teethId,
                                    deletion: false,
                                    eruptedDate: dateStr
                                )
                            }
                        }
                    }
                )
            }
        }
        .ignoresSafeArea()
        .alert("기록 삭제", isPresented: $isDeleteAlertPresented) {
            Button("삭제", role: .destructive) {
                if let teethId = teethIdToDelete {
                    Task {
                        await viewModel.setTeethStatus(
                            teethId: teethId,
                            deletion: true,
                            eruptedDate: nil
                        )
                    }
                }
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("선택한 치아 기록을 삭제하시겠습니까?")
        }
    }
}

private struct TeethEmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(.tooth)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
            
            Text("아직 난 치아가 없어요.")
                .font(.headline)
                .foregroundColor(.black)
            
            Text("위의 치아 그림을 탭하여\n첫 번째 유치가 나온 날짜를 기록해보세요!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            Text("주의: 다시 치아를 선택하면, 취소될 수 있습니다. ")
                .font(.system(size: 12, weight: .light))
                .foregroundStyle(Color.orange50)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
}

#Preview {
    TeethView(coordinator: BabyMoaCoordinator(), teethList: TeethData.mockData)
}
