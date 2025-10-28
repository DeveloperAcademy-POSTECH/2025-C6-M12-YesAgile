//
//  ProfileView.swift
//  babyMoa
//
//  Created by Baba on 10/22/25.
//

import SwiftUI

struct ProfileView: View {
    
    @State var isShowSheetView : Bool = false
    @State var items = ["엄마", "아빠","할머니", "할아버지","가족구성원" ]
    
    var sheetHeight: CGFloat {
        let ItemHeight: CGFloat = 60
        let ItemSpacing: CGFloat = 0
     return CGFloat(items.count) * ItemHeight + CGFloat(items.count) * ItemSpacing
    }
    
    
    var body: some View {
        VStack{
            TopNavigationBarView()
            
            //MARK: - Components 작업을 해야 한다.
                HStack{
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 70, height: 70)
                    
                    VStack(alignment: .leading){
                        Text("응애자일 | 응얘")
                        Text("1개월 20일")
                        Text("양육자 2명")
                    }
                    .padding(.horizontal, 10)
                    Spacer()
                }
                .padding(15)
                .background(Color.gray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(alignment: .topTrailing) {
                    Text("남아")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundStyle(.black)
                        .frame(width: 40, height: 16)
                        .background(Color.gray.opacity(0.5))
                        .clipShape(Capsule())
                        .offset(CGSize(width: -20.0, height: 20.0))
                        
                }
                .padding(.bottom, 16)
            
            //MARK: - Button Action 나중에 편집해야 한다.
            VStack(alignment: .leading, spacing: 16) {
                Button(action: {
                    isShowSheetView = true
                }, label: {
                    Text("양육자 편집")
                        .authButtonTextStyle(bgColor: .gray)
                })
                
                Button(action: {
                    
                }, label: {
                    
                    Text("공동 양육자 초대")
                        .authButtonTextStyle(bgColor: .gray)
                })
                
                Button(action: {
                    
                }, label: {
                    
                    Text("아기 추가")
                        .authButtonTextStyle(bgColor: .gray)
                })
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        //Sheet View에서 컨텐츠 크기에 따라서 높이 설정하는 방법이 있지 않을까??
        .sheet(isPresented: $isShowSheetView) {
            GuardianAddSheetView(items: items)
                .presentationDetents([.height(sheetHeight)])
                .presentationCompactAdaptation(.none)
        }
        
    }
}

#Preview {
    ProfileView()
}
