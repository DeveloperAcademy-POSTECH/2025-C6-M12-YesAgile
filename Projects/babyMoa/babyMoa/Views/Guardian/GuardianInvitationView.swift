//
//  GuardianInvitationCodeView.swift
//  babyMoa
//
//  Created by Baba on 10/22/25.
//

import SwiftUI

struct GuardianInvitationView: View {
    
    @StateObject private var viewModel: GuardianInvitationCodeViewModel
    
    init(viewModel: GuardianInvitationCodeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 20){
                CustomNavigationBar(title: "공동 육아자 초대", leading: {
                    // TODO: 이전 화면으로 돌아가는 로직 구현
                    // Button으로 구현하면 된다.
                    Button(action: {
                        viewModel.coordinator.pop()
                    }, label: {
                        Image(systemName: "chevron.left")

                    })
                })
                
                // 아기 프로필 이미지 표시
                if let imageUrlString = viewModel.selectedBabyImageURL, let url = URL(string: imageUrlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 70, height: 70)
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
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                } else {
                    Image("defaultAvata")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                }
                
                VStack{
                    Text(viewModel.selectedBabyName ?? "아기 이름")
                        .font(.system(size: 18, weight: .medium))
                        .padding(.bottom, 13)
                    Text("\(viewModel.birthDateLabel) 출생")
                        .font(.system(size: 14, weight: .medium))
                }
                
//                RelationshipSelectionView(
//                    relationship: $viewModel.relationship,
//                    showRelationshipPicker: $viewModel.showRelationshipPicker
//                )
                
                VStack(alignment: .leading){
                    Button("공동 양육자 초대 코드 생성", action: {
                        // 네트워크 통신 없이 바로 GuardianCodeView로 이동
                        // 추후 Task 함수를 이용해서 정상적으로 네트워크 통신이 이루어지면, 초대 코드를 받고 이동하는 화면을 구현해야 함
                        // 즉, viewModel에서 구현이 필요한 부분으로 현재는 라우팅 되는것만 우선 만듬.
                        // 내가 까먹을 수 있으니까.
                        viewModel.coordinator.push(path: .guardiainCode)
                    })
                    .buttonStyle(.defaultButton)
                }
                Spacer()
            }
            .backgroundPadding(.horizontal)
            
        }
        .ignoresSafeArea()
        .alert("오류", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
            Button("확인") { }
        } message: {
            Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.")
        }
    }
}

#Preview {
    GuardianInvitationView(viewModel: GuardianInvitationCodeViewModel(coordinator: BabyMoaCoordinator()))
}
