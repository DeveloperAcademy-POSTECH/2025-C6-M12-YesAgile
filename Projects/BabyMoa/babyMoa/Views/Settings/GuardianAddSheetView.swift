//
//  GuardianAddSheetView.swift
//  babyMoa
//
//  Created by Baba on 10/22/25.
//

import SwiftUI

struct GuardianAddSheetView: View {
    
    let itemHeight: CGFloat = 60
    let itemSpacing: CGFloat = 0
    
    private func deleteAction() -> some View{
        Button(role: .destructive) {
            //
        } label: {
            Image(systemName: "trash.fill")
            Text("Delete")
        }
        
    }
    
    var items:[String]
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: itemSpacing){
                
                //MARK: - List ForEach를 이용해서 화면을 만든다.
                List{
                    ForEach(items, id: \.self) { member in
                        HStack{
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .aspectRatio(contentMode: .fill)
                                .background(Color.gray.opacity(0.5))
                                .clipShape(Circle())
                            
                            Text(member)
                                .font(.system(size: 16, weight: .bold))
                                .padding(.horizontal, 16)
                            
                            Spacer()
                            
                            
                            Text("사용자")
                                .font(.system(size: 16, weight: .medium))
                            
                        }
                        .frame(height: itemHeight)
                        .swipeActions(edge: .trailing) {
                            deleteAction()
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(Color.clear)
                    
                }
                .listStyle(.plain)
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    GuardianAddSheetView(items: ["아빠","엄마"])
}
