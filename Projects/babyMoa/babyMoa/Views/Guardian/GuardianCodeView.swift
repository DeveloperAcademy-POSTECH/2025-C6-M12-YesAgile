//
//  GuardianCodeView.swift
//  babyMoa
//
//  Created by Baba on 10/22/25.
//

import SwiftUI

struct GuardianCodeView: View {
    
    let code: String
    let codeToCopy = "2025AppleCode44"
    @State private var copied = false
    
    @State var timer: Int = 60
    
    
    var body: some View {
        VStack{
            HStack{
                Text(codeToCopy)
                    .font(.system(size: 32, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.blue)
                    .padding(.top, 16)
                
                Button(action: {
                    UIPasteboard.general.string = codeToCopy
                }, label: {
                    Label("", systemImage: "doc")
                })
            }
            Group {
                Text("guardianCode.description1")
                
                Text("guardianCode.description2")
                
                Text("guardianCode.description3")
                
                Text("guardianCode.expiration.label")
                
            }
            .padding(.vertical, 12)
            .multilineTextAlignment(.center)
            .font(.system(size: 14))
            
            Button(action: {
                
            }, label: {
                Text("guardianCode.cancelButton")
                    .authButtonTextStyle(bgColor: .blue)
            })
            Spacer()
        }
        .padding(16)
        
    }
}

#Preview {
    GuardianCodeView(code: "234567")
}
