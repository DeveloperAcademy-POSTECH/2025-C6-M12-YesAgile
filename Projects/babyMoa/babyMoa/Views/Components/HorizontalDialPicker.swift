//
//  HorizontalDialPicker.swift
//  BabyMoa
//
//  Created by Baba on 11/12/25.
//

import SwiftUI

struct HorizontalDialPicker<ValueType>: View where ValueType: BinaryFloatingPoint, ValueType.Stride : BinaryFloatingPoint {
    
    @Binding var value: ValueType
    var range: ClosedRange<ValueType>
    var step: ValueType
    
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
                // .onAppear에서 하던 작업을 여기서 수행합니다.
                self.scrollPosition = Int(value / step - range.lowerBound)
            }
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, content: {
            let totalTicks = Int((range.upperBound - range.lowerBound) / step) + 1
            
            HStack(spacing: tickSpacing) {
                ForEach(0..<totalTicks, id: \.self) { index in
                    
                    let isSegment = index % tickSegmentCount == 0
                    let isTarget = index == scrollPosition
                    
                    RoundedRectangle(cornerRadius: 2)
                        // 원하시는 색상으로 변경 (예: .blue)
                        .fill(isTarget ? .blue : isSegment ? .black : .gray)
                        .frame(width: 3, height: 24)
                        .id(index)
                        .scaleEffect(x: isTarget ? 1.2 : 1, y: isTarget ? 1.5 : 0.8, anchor: .bottom)
                        .animation(.default.speed(1.2), value: isTarget)
                        .sensoryFeedback(.selection, trigger: isTarget && initialized)
                        .overlay(alignment: .bottom, content: {
                            if isSegment, self.showSegmentValueLabel {
                                let value = Double(range.lowerBound + ValueType(index) * step)
                                Text("\(String(format: "%.\(labelSignificantDigit)f", value))")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .fixedSize()
                                    .offset(y: 16)
                            }
                        })
                }
            }
            .scrollTargetLayout()
            .padding(.vertical, 16)
        })
        .onAppear {
            // 👈 2. .onAppear에서는 햅틱 초기화만 수행합니다.
            //    (초기 스크롤 로직은 viewSize.didSet으로 이동됨)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.initialized = true
            })
        }
        .onChange(of: value) {
            self.scrollPosition = Int(value / step - range.lowerBound)
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .defaultScrollAnchor(.center, for: .alignment)
        .defaultScrollAnchor(.center, for: .initialOffset)
        .defaultScrollAnchor(.center, for: .sizeChanges)
        .onChange(of: scrollPosition, {
            guard let scrollPosition = self.scrollPosition, initialized else { return } // 👈 햅틱 초기화 후 값 변경
            value = range.lowerBound + ValueType(scrollPosition) * step
        })
        .safeAreaPadding(.horizontal, (viewSize?.width ?? 0)/2)
        .overlay(content: {
            // 👈 3. GeometryReader는 viewSize를 설정하는 역할만 합니다.
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
