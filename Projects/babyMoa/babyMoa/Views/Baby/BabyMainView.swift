//
//  BabyMainView.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

// BabyHeaderView 에서 Sheet을 움직일 수 있게 해야 한다..

import SwiftUI

struct BabyMainView: View {
    
    @StateObject private var viewModel = BabyMainViewModel()
    @State private var sheetHeight: CGFloat = .zero
    
    var body: some View {
        ZStack {
            Color.background
            VStack(alignment: .leading, spacing: 20){
                // BabyHeadrView에서 버튼을 클릭하면 하단에 SheetView가 나오게 하면 됩니다.
                BabyHeaderView()
                                
                // 아기 카드
                VStack(spacing: 8){
                    HStack(spacing: 15){
                        Image("baby_milestone_illustration")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            
                        VStack(alignment:.leading, spacing: 0){
                            HStack{
                                Text("김도율(꼬물이)")
                                    .font(.system(size: 16, weight: .bold))
                                Text("남아")
                                    .font(.system(size: 14, weight: .medium))
                                    .frame(width: 50, height: 25)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                    .overlay {
                                        Capsule()
                                            .stroke(Color.gray90, lineWidth: 2)
                                    }
                                
                            }
                            .padding(.bottom, 11)
                            Text("1개월 20일")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.bottom, 8)
                            
                            Text("엄마")
                                .frame(width: 41, height: 20)
                                .foregroundStyle(Color.brand50)
                                .font(.system(size: 11, weight: .medium))
                                .background(Color.brand40.opacity(0.1))
                                .clipShape(Capsule())
                               
                        }
                        Spacer()
                        Button(action: {
                            // 다음 페이지로 이동하기
                        }, label: {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.gray40.opacity(0.3))
                                .font(.system(size: 17, weight: .semibold))
                                
                        })
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray90, lineWidth: 1)
                }
                
                //Components 아기 카드 리스트
                
                VStack(alignment: .leading){
                    Text("양육자")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.font)
                    Button(action: {
                        // 어디로 갈것인가? 초대 코드 생성으로 이동한다.
                    }, label: {
                        HStack{
                            Text("공동 양육자 초대")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        
                    })
                    .buttonStyle(.outlinelessButton)
                }
                
                VStack(alignment: .leading){
                    Text("아기")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.font)
                    Button(action: {
                        // 어디로 갈것인가?
                    }, label: {
                        HStack{
                            Text("아기추가")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        
                    })
                    .buttonStyle(.outlinelessButton)
                }
                
                Button("로그아웃", action: {
                    // 로그아웃 기능 만들기
                })
                .buttonStyle(.outlineThirdButton)
                
                
                Spacer()
               
            }
            .padding(.top, 44)
            .backgroundPadding(.horizontal)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $viewModel.isShowingSheet) {
            
            BabyListView(babies: viewModel.babies)
            
                .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                    if newHeight > 0 {
                        sheetHeight = newHeight
                        print("Calculated sheet height: \(newHeight)")
                    }
                }
                .presentationDetents(
                    sheetHeight > 0 ? [.height(sheetHeight)] : [.medium]
                )
                .presentationCornerRadius(25)
                .presentationDragIndicator(.visible)
        }
        
        
    }
}


#Preview {
    BabyMainView()
}
