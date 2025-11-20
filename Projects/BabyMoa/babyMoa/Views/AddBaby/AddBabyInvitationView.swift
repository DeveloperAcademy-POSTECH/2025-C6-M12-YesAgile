//
//  AddBabyInvitationView.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import SwiftUI

struct AddBabyInvitationView: View {
    
    @StateObject private var viewModel: AddBabyViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    init(coordinator: BabyMoaCoordinator) {
        self._viewModel = StateObject(wrappedValue: AddBabyViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        ZStack {
            Color.background
            VStack{
                // CustomeNavigation View
                CustomNavigationBar(title: "설정", leading: {
                    Button(action: {
                        // 버튼 클릭
                        print("뒤로가기 버튼을 클릭했습니다.")
                        viewModel.coordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                        
                    }
                })
                
                ScrollView {
                    // --- 타이틀 ---
                    Text("addBabyInvitation.title")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 40) // 화면 상단 여백
                    
                    // --- 설명 ---
                    Text("addBabyInvitation.description")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                        .padding(.bottom, 20) // 텍스트필드와의 여백
                    
                    // --- 텍스트필드 ---
                    TextField("addBabyInvitation.textField.placeholder", text: $viewModel.invitationCode)
                        .textFieldStyle(.borderedForm)
                        .multilineTextAlignment(.center)
                        .focused($isTextFieldFocused)
                    
                    Button("보내기") {
                        viewModel.coordinator.push(path: .growth)
                    }
                    .buttonStyle(viewModel.isInvitationCodeValid ? .defaultButton : .noneButton)
                    .disabled(!viewModel.isInvitationCodeValid)
                    
                    Spacer() // 나머지 공간을 모두 밀어냄
                }
                .scrollIndicators(.hidden)
            }
            .backgroundPadding(.horizontal)
            
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused = false
        }
        
    }
    
}

#Preview {
    AddBabyInvitationView(coordinator: BabyMoaCoordinator())
}
