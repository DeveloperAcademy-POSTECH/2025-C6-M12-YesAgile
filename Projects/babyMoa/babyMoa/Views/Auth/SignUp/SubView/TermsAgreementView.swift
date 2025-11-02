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
    var body: some View {
        VStack(spacing: 0) {
            Text("약관에 동의해주세요.")
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(.black)
                .padding(.bottom, 20)
            ForEach(0..<termCheckList.count, id: \.self) { idx in
                HStack(spacing: 0) {
                    Button(action: {
                        termCheckList[idx].isChecked.toggle()
                    }) {
                        Circle()
                            .stroke(.gray, lineWidth: 1)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.black)
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
                .padding(.bottom, 20)
            }
        }
        .padding(.leading, 25)
        .padding(.trailing, 20)
    }
}
