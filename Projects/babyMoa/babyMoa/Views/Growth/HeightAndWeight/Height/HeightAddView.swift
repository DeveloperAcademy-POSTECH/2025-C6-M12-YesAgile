//
//  HeightAddView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct HeightAddView: View {
    
    let coordinator: BabyMoaCoordinator

    // 측정일
    @State private var measuredDate: Date = Date()

    // 키 값 (cm)
    @State private var heightValue: Double = 73.1

    // 키 TextField용 문자열
    @State private var heightText: String = "73.1"

    // 메모
    @State private var memo: String = ""

    // 날짜 피커 표시 여부
    @State private var showDatePicker: Bool = false

    // 메모 TextEditor 포커스 상태
    @FocusState private var isFocused: Bool
    
    // 키 범위 (예: 40cm ~ 120cm)
    private let minHeight: Double = 40.0
    private let maxHeight: Double = 120.0

    var body: some View {
        ZStack {
            Color.background
               
            VStack(spacing: 0) {

                // 상단 네비게이션 바
                CustomNavigationBar(title: "키 기록", leading: {
                    Button {
                        coordinator.pop() // 뒤로가기 액션 구현
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                })

                VStack(alignment: .leading, spacing: 20) {

                    // MARK: - 측정일
                    VStack(alignment: .leading, spacing: 8) {
                        Text("측정일")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.black)

                        Button(action: {
                            showDatePicker = true
                        }) {
                            HStack {
                                Spacer()

                                Text(measuredDate, formatter: DateFormatter.yyyyMMdd)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("Font"))

                                Spacer()
                            }
                        }
                        .buttonStyle(.outlineMileButton)
                    }

                    // MARK: - 키
                    VStack(alignment: .leading, spacing: 8) {
                        Text("키")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.black)

                        Button(action: {
                            // TODO: 키 직접 입력용 액션 (Alert / Sheet 등)
                        }) {
                            HStack {
                                Spacer()

                                Text("\(String(format: "%.1f", heightValue)) cm")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("Font"))

                                Spacer()
                            }
                        }
                        .buttonStyle(.outlineMileButton)
                    }


                    // MARK: - 눈금 + 슬라이더
                    HorizontalDialPicker(
                        value: $heightValue,
                        range: 0.0...100.0,
                        step: 0.1
                    )

                    // MARK: - 메모                    
                    MemoTextEditor(
                        memo: $memo,
                        limit: 300,
                        isFocused: $isFocused
                    )

                    Spacer()
                }

                Button("저장", action: {
                    // TODO: 저장 액션 구현
                })
                .buttonStyle(.defaultButton)
            }
            .backgroundPadding(.horizontal)
            .padding(.bottom, 44)


            // 날짜 피커 모달
            if showDatePicker {
                DatePickerModal(
                    birthDate: $measuredDate,
                    showDatePicker: $showDatePicker,
                    style: .graphical,
                    components: .date
                )
            }
        }
        .ignoresSafeArea()
        .simultaneousGesture(   // ✅ 버튼 동작 + 키보드 내리기 둘 다 가능
            TapGesture().onEnded {
                isFocused = false
            }
        )
    }
}



#Preview {
    HeightAddView(coordinator: BabyMoaCoordinator())
}
