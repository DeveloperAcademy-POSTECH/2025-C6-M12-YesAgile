//
//  CardItemView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct CardItemView<Content: View>: View {
    
    let title: String
    let value: String
    let backgroundColor: Color
    let content: Content // 👈 @ViewBuilder로 받을 내용 (이미지 레이아웃)

    init(title: String,
         value: String,
         backgroundColor: Color,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.value = value
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    var body: some View {
        ZStack {
            // 1️⃣ 카드 배경 (표준화된 부분)
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
                .overlay {
                    ZStack {
                        // 🔹 테두리 (표준화된 부분)
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 2)

                        // 🔹 내용물 (상황에 따라 달라지는 부분)
                        HStack {
                            Spacer()
                            content // 👈 기린/코끼리 레이아웃이 여기에 들어옴
                        }
                        .padding(2)
                    }
                }
            
            // 2️⃣ 콘텐츠 (표준화된 부분)
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                    Text(value)
                        .font(.system(size: 16))
                    
                    Spacer()
                }
                .foregroundStyle(.white)
                .frame(width: 65)
                .padding(.top, 16)
                .padding(.leading, 16)
                
                Spacer()
            }
        }
        .frame(height: 100)
    }
}


#Preview{
    VStack{
        // 1. 기린 카드
        CardItemView(title: "키", value: "37.5cm", backgroundColor: Color.orange50) {
            // 👇 기린의 고유한 레이아웃 전달
            Image("GiraffeNeck")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: .infinity)
                .padding(.trailing, 18)
        }
        
        // 2. 코끼리 카드
        CardItemView(title: "몸무게", value: "10.2kg", backgroundColor: Color.green80) {
            // 👇 코끼리의 고유한 레이아웃(VStack+Spacer) 전달
            VStack {
                Spacer()
                Image("elephantCropImg")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 72)
                    .padding(.trailing, 11)
            }
        }
    }
}
