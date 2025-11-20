//
//  TermsAgreementView.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

struct TermsAgreementView: View {
    var terms = Term.allCases
    @Binding var termCheckList: [TermCheckItem]
    
    private var isAllChecked: Bool {
        termCheckList.allSatisfy { $0.isChecked }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("약관에 동의해주세요")
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(.black)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            
            HStack(spacing: 0){
                Button(action: {
                    let newValue = !isAllChecked
                    for index in termCheckList.indices {
                        termCheckList[index].isChecked = newValue
                    }
                }, label: {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.gray, lineWidth: 1)
                        .frame(width: 22, height: 22)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .frame(width: 22, height: 22)
                                .foregroundStyle(Color.brandMain)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(.white)
                                )
                                .opacity(isAllChecked ? 1 : 0)
                        }
                })
                .padding(.trailing, 10)
                Text("전체 동의하기")
                    .font(.system(size: 20, weight: .medium))
                Spacer()
            }
            
            Divider()
            
            ForEach(0..<termCheckList.count, id: \.self) { idx in
                HStack(spacing: 0) {
                    Button(action: {
                        termCheckList[idx].isChecked.toggle()
                    }) {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.gray, lineWidth: 1)
                            .frame(width: 22, height: 22)

                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: 22, height: 22)
                                    .foregroundStyle(Color.brandMain)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                            .foregroundStyle(.white)
                                    )
                                    .opacity(termCheckList[idx].isChecked ? 1 : 0)
                            )
                        
                    }
                    .padding(.trailing, 10)
                    Text(termCheckList[idx].term.termString)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    if let moreAction = termCheckList[idx].moreAction {
                        Button(action: {
                            moreAction()
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
        }
        .padding(.leading, 25)
        .padding(.trailing, 20)

    }
}
