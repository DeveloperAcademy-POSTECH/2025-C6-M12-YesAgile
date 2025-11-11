//
//  HeightView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct HeightView: View {
    var body: some View {
        
        HStack(spacing: 20){
            ZStack {
                // 1️⃣ 카드 배경
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.orange50)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
                    .overlay {
                        ZStack {
                            // 🔹 테두리를 안쪽으로 그리기
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.white.opacity(0.3), lineWidth: 2)

                            // 🔹 기린을 테두리 안쪽으로 밀어넣기
                            HStack {
                                Spacer()
                                Image("GiraffeNeck")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: .infinity)
                                    .padding(.trailing, 18)
                            }
                            .padding(2)   // ← 이 여백 덕분에 테두리 안쪽에서 시작됨
                        }
                    }
                
                // 2️⃣ 콘텐츠 (글자 + 이미지)
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("키")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        Text("37.5cm")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .frame(width: 65)
                    .padding(.top, 18)
                    .padding(.leading, 15)
                    Spacer()
                }
            }
            .frame(height: 100)
            
            
            ZStack {
                // 1️⃣ 카드 배경
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.green80)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
                    .overlay {
                        ZStack {
                            // 🔹 테두리를 안쪽으로 그리기
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.white.opacity(0.3), lineWidth: 2)

                            // 🔹 기린을 테두리 안쪽으로 밀어넣기
                            HStack {
                                Spacer()
                                VStack{
                                    Spacer()
                                    Image("elephantCropImg")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 72)
                                        .padding(.trailing, 11)
                                }
                            }
                            .padding(2)   // ← 이 여백 덕분에 테두리 안쪽에서 시작됨
                        }
                    }
                
                // 2️⃣ 콘텐츠 (글자 + 이미지)
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("키")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        Text("37.5cm")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .frame(width: 65)
                    .padding(.top, 18)
                    .padding(.leading, 15)
                    Spacer()
                }
            }
            .frame(height: 100)

            
 
        }
       
    }
}

#Preview {
    HeightView()
}

