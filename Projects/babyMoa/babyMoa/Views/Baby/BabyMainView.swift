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
            Color.white
            
            VStack{
                BabyHeaderView()
                Divider()
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "authAvata")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .background(Color.red)

                        
                        
                    }
                    
                }
                
                
                Spacer()
                Button("아기 목록 보기") {
                    // ViewModel에 "요청"합니다.
                    viewModel.showBabyListSheet()
                }
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
