//
//  BabyHeaderView.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import SwiftUI

struct BabyHeaderView: View {
    var body: some View {
        ZStack{
            HStack(spacing: 20){
                Image("baby_milestone_illustration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                
                HStack(spacing: 5){
                    Text("김도율")
                        .font(.system(size: 16, weight: .bold))
                    
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color.brand50)
                        .font(.system(size: 14, weight: .bold))
                }
                
                Spacer()
            }
            
            HStack{
                Spacer()
                
                Image(systemName: "gearshape")
                    .foregroundStyle(Color.brand50)
                    .font(.system(size: 22, weight: .bold))
            }
        }
        .frame(height: 91)
    }
}

#Preview {
    BabyHeaderView()
}
