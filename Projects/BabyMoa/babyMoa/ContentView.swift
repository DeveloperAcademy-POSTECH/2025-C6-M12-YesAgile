//
//  ContentView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
        
            Text("Main Title")
            
            Spacer()
            
            
            VStack{
                Button(action: {
                    
                }, label: {
                    Text("회원가입하기")
                        .authButtonTextStyle(bgColor: .blue)
                })

                
                Button(action: {
                    
                }, label: {
                    Text("로그인 하기")
                        .authButtonTextStyle(bgColor: .red)
                  
                })
            }
            .padding()
         
        }
    }
}

#Preview {
    ContentView()
}
