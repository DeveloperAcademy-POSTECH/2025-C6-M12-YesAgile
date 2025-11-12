//
//  HeightAddView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct HeightAddView: View {
    
    // 측정일
    @State private var measuredDate: Date = Date()
    // 키 값 (cm)
    @State private var heightValue: Double = 73.1
    
    // 키 TextField용 문자열
    @State private var heightText: String = "73.1"
    
    // 메모
    @State private var memo: String = ""
    
    //
    @State private var showDatePicker: Bool = false
    
    // 키 범위 (예: 40cm ~ 120cm)
    private let minHeight: Double = 40.0
    private let maxHeight: Double = 120.0
    

    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                
                // 상단 네비게이션 바
                CustomNavigationBar(title: "키 기록", leading: {
                    Button {
                        // 뒤로가기 액션
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                })
                
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - 측정일
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("측정일")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.black)
                        
                        Button(action: { showDatePicker = true }) {
                            HStack {
                                Spacer()
                                Text("2025.10.21")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("Font"))
                                Spacer()
                                
                            }
                        }
                        .buttonStyle(.outlineDefaultButton)
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
                                Text("\(String(format: "%.1f", heightValue)) cm")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("Font"))
                                Spacer()
                                
                            }
                        })
                        .buttonStyle(.outlineDefaultButton)
                    }
                    
                    // MARK: - 눈금 + 슬라이더
                    HorizontalDialPicker(value: $heightValue, range: 0.0...100.0, step: 0.1)
                    
                    // MARK: - 메모
                    
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("메모")
                            .font(.system(size: 15, weight: .regular))
                        
                        TextField("", text: $memo, prompt: Text("").foregroundStyle(.black))
                            .textFieldStyle(.borderedBrandLightForm)
                    }
                    
                    Spacer(minLength: 40)
                }
                
                Button("저장", action: {
                    //print("저장하기 버튼을 구현하자")
                })
                .buttonStyle(.defaultButton)
                
                
            }
            .backgroundPadding(.horizontal)
            .padding(.bottom, 44)
        }
        .ignoresSafeArea()
    }
    
}

// MARK: - 눈금 뷰
struct HeightScaleView: View {
    let currentValue: Double
    let minValue: Double
    let maxValue: Double
    
    private let majorStep: Double = 5   // 큰 눈금 간격
    private let minorStep: Double = 1   // 작은 눈금 간격
    
    var body: some View {
        let totalRange = Int(maxValue - minValue)
        
        HStack(spacing: 4) {
            ForEach(0...totalRange, id: \.self) { index in
                let value = minValue + Double(index)
                let isMajor = value.truncatingRemainder(dividingBy: majorStep) == 0
                let isCurrent = abs(value - roundedCurrent) < 0.5
                
                Rectangle()
                    .fill(isCurrent ? Color.orange : Color.gray.opacity(0.4))
                    .frame(
                        width: isMajor ? 2 : 1,
                        height: isMajor ? 28 : 16
                    )
            }
        }
        .frame(height: 32)
        .clipped()
    }
    
    private var roundedCurrent: Double {
        (currentValue * 1).rounded() / 1
    }
}

#Preview {
    HeightAddView()
}
