//
//  BabyListView.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import SwiftUI

// (이전에 ExtractedView였던 뷰)
struct BabyListView: View {
    
    //BabyMainView로부터 babies 데이터를 받습니다.
    let babies: [Babies]
    
    var body: some View {
        VStack(spacing: 20){
            // 전달받은 'babies' ForEach는 해결해야 한다.
            ForEach(babies) { baby in
                HStack(spacing: 20){
                    Image(baby.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    
                    Text(baby.name) // 아기 이름
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                }
            }
            
            Button(action: {
                // (나중에: viewModel.addBaby() 호출)
                
            }, label: {
                HStack(spacing: 20){
                    Image(systemName: "plus")
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color.gray50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundColor(Color.gray50.opacity(0.4))                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    Text("아기 추가")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.font)
                    Spacer()
                }
            })
        }
        .padding(.top, 20)
        .background(
            GeometryReader {
                Color.clear.preference(key: HeightPreferenceKey.self, value: $0.size.height)
            }
        )
        .backgroundPadding(.horizontal)
    }
}

// (HeightPreferenceKey 정의)
struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// 프리뷰를 위해 목업 데이터 사용
#Preview {
    BabyListView(babies: Babies.mockBabies)
}
