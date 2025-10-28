//
//  TopNavigationView.swift
//  babyMoa
//
//  Created by Baba on 10/22/25.
//

import SwiftUI

struct TopNavigationBarView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .padding()
                .background(.gray.opacity(0.5))
                .foregroundStyle(.black)
                .clipShape(Circle())
            
            Text("아기이름")
                .font(.system(size: 16, weight: .semibold))
            
            Button(action: {
                
            }, label: {
                Image(systemName: "chevron.down")
                    .foregroundStyle(.black)
                    
            })
            Spacer()
        }
        
    }
}

#Preview {
    TopNavigationBarView()
}
