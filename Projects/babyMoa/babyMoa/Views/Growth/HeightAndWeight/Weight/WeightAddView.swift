//
//  WeightAddView.swift
//  BabyMoa
//
//  Created by Baba on 11/13/25.
//

import SwiftUI

struct WeightAddView: View {
    
    let coordinator: BabyMoaCoordinator
    // 측정일
    @State private var measuredDate: Date = Date()
    // 키 값 (cm)
    @State private var weightValue: Double = 8.1
    
    // 키 TextField용 문자열
    @State private var weightText: String = "8.1"
    
    // 메모
    @State private var memo: String = ""
    
    // 날짜 피커 표시 여부
    @State private var showDatePicker: Bool = false

    // 메모 TextEditor 포커스 상태
    @FocusState private var isFocused: Bool
    
    // 키 범위 (예: 40cm ~ 120cm)
    private let minWeight: Double = 2.0
    private let maxWeight: Double = 120.0
    

    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                
                // 상단 네비게이션 바
                CustomNavigationBar(title: "몸무게 기록", leading: {
                    Button {
                        coordinator.pop() // 뒤로가기 액션 구현
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                })
                
                
                VStack(alignment: .leading, spacing: 24) {
                    
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
                        .buttonStyle(.outlineDefaultLightButton)
                    }
                    
                    //MARK: - 키
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("키")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.black)
                        
                        Button(action: {
                            // 키를 입력할 수 있게 해야 한다. 어떻게 해야 되는가?
                            // 이것을 해결하면 체중을 입력하는것과 동일하다.
                        }, label: {
                            HStack {
                                Spacer()
                                Text("\(String(format: "%.1f", weightValue)) kg")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("Font"))
                                Spacer()
                                
                            }
                        })
                        .buttonStyle(.outlineDefaultButton)
                    }
                    
                    // MARK: - 눈금 + 슬라이더
                    HorizontalDialPicker(value: $weightValue, range: 0.0...100.0, step: 0.1)
                    
                    // MARK: - 메모
                    MemoTextEditor(
                        memo: $memo,
                        limit: 300,
                        isFocused: $isFocused
                    )

                    Spacer()
                }
                
                Button("저장", action: {
                    //print("저장하기 버튼을 구현하자")
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
    WeightAddView(coordinator: BabyMoaCoordinator())
}
