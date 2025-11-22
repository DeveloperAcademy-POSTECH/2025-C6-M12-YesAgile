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
        VStack {
            // CustomeNavigation View
            CustomNavigationBar(title: "초대 코드 연결", leading: {
                Button(action: {
                    viewModel.coordinator.pop()
                }) {
                    Image(systemName: "chevron.left")
                }
            })
            
            if let baby = viewModel.editingBaby, viewModel.inviteCodeAccessComplete {
                CachedAsyncImage(urlString: baby.profileImage) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 50, height: 50)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image("defaultAvata")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                .padding(.bottom, 10)
                Text(baby.name)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.bottom, 10)
                Text("\(baby.birthDate.yyyyMMdd) 출생")
                    .font(.system(size: 14, weight: .medium))
                    .padding(.bottom, 10)
                RelationshipSelectionView(relationship: $viewModel.relationship, showRelationshipPicker: $viewModel.showRelationshipPicker)
                    .padding(.bottom, 10)
                Button(action: {
                    Task {
                        await viewModel.completeSelectRelationship()
                    }
                }) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.brand50)
                        .frame(height: 50)
                        .overlay(
                            Text("연결")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.white)
                        )
                }
            }
            else {
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
                    Task {
                        await viewModel.addBabyByInvitationCode()
                    }
                }
                .buttonStyle(viewModel.isInvitationCodeValid ? .defaultButton : .noneButton)
                .disabled(!viewModel.isInvitationCodeValid)
            }
            
            
            Spacer()
        }
        .backgroundPadding(.horizontal)
        .background(Color.background)
        .ignoresSafeArea()
        .onTapGesture {
            isTextFieldFocused = false
        }
        .overlay(
            RelationshipPickerModal(relationship: $viewModel.relationship, showRelationshipPicker: $viewModel.showRelationshipPicker)
                .opacity(viewModel.showRelationshipPicker ? 1 : 0)
                .animation(.spring, value: viewModel.showRelationshipPicker)
        )
    }
    
}

#Preview {
    AddBabyInvitationView(coordinator: BabyMoaCoordinator())
}
