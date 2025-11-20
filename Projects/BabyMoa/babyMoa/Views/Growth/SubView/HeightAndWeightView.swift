//
//  HeightAndWeightView.swift
//  babyMoa
//
//  Created by 한건희 on 11/3/25.
//

import SwiftUI

struct HeightAndWeightView: View {
    @Binding var height: Double?
    @Binding var weight: Double?
    var heightTapAction: () -> Void
    var weightTapAction: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                heightTapAction()
            }) {
                RoundedRectangle(cornerRadius: 16)
                    .overlay(
                        HStack {
                            VStack(alignment: .leading) {
                                Text("키")
                                    .font(.system(size: 18, weight:. bold))
                                if let height {
                                    Text("\(String(height))cm")
                                        .font(.system(size: 18))
                                } else {
                                    Text("기록 없음")
                                        .font(.system(size: 18))
                                }
                                Spacer()
                            }
                            .foregroundStyle(.white)
                            
                            VStack(spacing: 0) {
                                Spacer()
                                Image("GiraffeNeck")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 64)
                            }
                        }
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                    )
                    .foregroundStyle(.orange50)
            }
            
            Spacer().frame(width: 20)
            
            Button(action: {
                weightTapAction()
            }) {
                RoundedRectangle(cornerRadius: 16)
                    .overlay(
                        ZStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("몸무게")
                                        .font(.system(size: 18, weight:. bold))
                                    if let weight {
                                        Text("\(String(weight))kg")
                                            .font(.system(size: 18))
                                    } else {
                                        Text("기록 없음")
                                            .font(.system(size: 18))
                                    }
                                    Spacer()
                                }
                                .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                            HStack {
                                Spacer()
                                VStack(spacing: 0) {
                                    Spacer()
                                    Image("ElephantNeck")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 95)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                        }
                    )
                    .foregroundStyle(Color(uiColor: UIColor(red: 0.42, green: 0.6, blue: 0.35, alpha: 1)))
            }
        }
    }
}
