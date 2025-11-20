//
//  HorizontalDialPicker.swift
//  BabyMoa
//
//  Created by Baba on 11/12/25.
//

import SwiftUI

struct HorizontalDialPicker<ValueType>: View where ValueType: BinaryFloatingPoint, ValueType.Stride : BinaryFloatingPoint {
    
    @Binding var value: ValueType
    var range: ClosedRange<ValueType>
    var step: ValueType // 💡 이제 이 step에 실제 단위(예: 0.1)를 설정합니다.
        
    var tickSpacing: CGFloat = 10.0
    var tickSegmentCount: Int = 10
    var showSegmentValueLabel: Bool = true
    var labelSignificantDigit: Int = 1
    
    @State private var scrollPosition: Int? = nil
    @State private var initialized: Bool = false
    
    // 👈 1. viewSize 변수에 didSet 옵저버를 추가합니다.
    @State private var viewSize: CGSize? = nil {
        didSet {
            // viewSize가 처음 설정될 때 (oldValue == nil)
            // 초기 스크롤 위치를 계산합니다.
            if oldValue == nil && viewSize != nil {
                // 💡 수정 1: 초기 scrollPosition 계산 시 부동 소수점 오차 보정 (round())
                let targetIndex = (value - range.lowerBound) / step
                self.scrollPosition = Int(targetIndex.rounded())
            }
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, content: {
            // totalTicks 계산: 부동 소수점 오차 보정 (round())을 사용하여 정확한 틱 개수 계산
            let difference = range.upperBound - range.lowerBound
            let count = difference / step
            let safeCount = count.rounded()
            let totalTicks = Int(safeCount) + 1
            
            HStack(spacing: tickSpacing) {
                ForEach(0..<totalTicks, id: \.self) { index in
                    
                    let isSegment = index % tickSegmentCount == 0
                    let isTarget = index == scrollPosition
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(isTarget ? Color.brandLight : isSegment ? .black : .gray)
                        .frame(width: 3, height: 30)
                        .id(index)
                        .scaleEffect(x: isTarget ? 1.2 : 1, y: isTarget ? 1.5 : 0.8, anchor: .bottom)
                        .animation(.default.speed(1.2), value: isTarget)
                        .sensoryFeedback(.selection, trigger: isTarget && initialized)
                        .overlay(alignment: .bottom, content: {
                            if isSegment, self.showSegmentValueLabel {
                                // 💡 수정 3: 틱 레이블 값 계산 시 부동 소수점 오차 보정 (round() 기반)
                                let theoreticalValue = range.lowerBound + ValueType(index) * step
                                
                                // 오차를 보정하여 가장 가까운 step 배수로 만듭니다.
                                let roundedValue = (theoreticalValue / step).rounded() * step
                                let displayValue = Double(roundedValue)
                                
                                // 줄자 하단에 숫자를 보여줄 것인가 ?? 현재는 보여지도록 구현했고 상황에 따라서 변경할 수 있다.
                                
                                Text("\(String(format: "%.\(labelSignificantDigit)f", displayValue))")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .fixedSize()
                                    .offset(y: 40)
                            }
                        })
                }
            }
            .scrollTargetLayout()
            .padding(.vertical, 20)
        })
        .onAppear {
            // 햅틱 초기화만 수행합니다.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.initialized = true
            })
        }
        .onChange(of: value) {
            // 💡 수정 2: 외부 value 변경 시 scrollPosition 계산에 부동 소수점 오차 보정 (round())
            let targetIndex = (value - range.lowerBound) / step
            self.scrollPosition = Int(targetIndex.rounded())
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .defaultScrollAnchor(.center, for: .alignment)
        .defaultScrollAnchor(.center, for: .initialOffset)
        .defaultScrollAnchor(.center, for: .sizeChanges)
        .onChange(of: scrollPosition, {
            guard let scrollPosition = self.scrollPosition, initialized else { return }
            // scrollPosition을 사용하여 정확하게 value를 계산합니다.
            value = range.lowerBound + ValueType(scrollPosition) * step
        })
        .safeAreaPadding(.horizontal, (viewSize?.width ?? 0)/2)
        .overlay(content: {
            // GeometryReader는 viewSize를 설정하는 역할만 합니다.
            GeometryReader { geometry in
                if geometry.size != self.viewSize {
                    DispatchQueue.main.async {
                        self.viewSize = geometry.size
                    }
                }
                return Color.clear
            }
        })
    }
}
