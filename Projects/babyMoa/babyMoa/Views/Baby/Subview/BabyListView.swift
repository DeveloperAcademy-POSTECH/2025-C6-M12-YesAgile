//
//  BabyListView.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import SwiftUI

struct BabyListView: View {
    
    let babies: [Babies]
    let onSelectBaby: (Babies) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    init(babies: [Babies], onSelectBaby: @escaping (Babies) -> Void) {
        self.babies = babies
        self.onSelectBaby = onSelectBaby
    }
    
    var body: some View {
        VStack(spacing: 20){
            ForEach(babies) { baby in
                Button(action: { onSelectBaby(baby) }) {
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
                            .foregroundColor(.black) // 버튼으로 감싸면 기본 색상이 tint로 변경되므로 명시적으로 지정
                        
                        Spacer()
                    }
                }
            }
            
            Button(action: {
                // TODO: viewModel.addBaby() 호출
            }) {
                HStack(spacing: 20){
                    Image(systemName: "plus")
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color.gray50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundColor(Color.gray50.opacity(0.4))
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    Text("아기 추가")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.font)
                    Spacer()
                }
            }
        }
        .padding(.top, 40)
        .background(
            GeometryReader {
                Color.clear.preference(key: HeightPreferenceKey.self, value: $0.size.height)
            }
        )
        .backgroundPadding(.horizontal)
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    BabyListView(babies: Babies.mockBabies, onSelectBaby: { baby in
        print("\(baby.name) selected")
    })
}
