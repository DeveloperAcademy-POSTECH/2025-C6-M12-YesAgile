//
//  GuardianCodeView.swift
//  babyMoa
//
//  Created by Baba on 10/22/25.
//

import SwiftUI

struct GuardianCodeView: View {
    
    // ViewModel 인스턴스를 전달받습니다.
    @StateObject var viewModel: GuardianInvitationCodeViewModel
    @State private var isShowingCancelAlert = false
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: 20){
                CustomNavigationBar(title: "공동 양육자 초대", leading: {
                    Button(action: {
                        viewModel.coordinator.pop()
                    }, label: {
                        Image(systemName: "chevron.left")

                    })
                })
                
                // TODO: ViewModel에서 실제 아기 프로필 이미지 가져오기
                BabyProfileImageView()
                
                VStack(alignment: .center, spacing: 11){
                    Text(viewModel.babyName)
                        .font(.system(size: 18, weight: .medium))
                        .multilineTextAlignment(.center)
                    Text("초대할 양육자에게 \n 초대 코드를 전달해 주세요.")
                        .font(.system(size: 14, weight: .medium))
                        .multilineTextAlignment(.center)
                }
                
                // --- 초대 코드 표시 영역 ---
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        // ViewModel의 초대 코드를 표시합니다.
                        Text(viewModel.generatedInvitation?.code ?? "")
                            .inviteTextStyle(
                                fontSize: 24,
                                bgColor: .white,
                                fontColor: .font,
                                borderColor: viewModel.isCodeCopied ? .red : Color("orange50")
                            )
                            .overlay {
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        // ViewModel의 복사 함수 호출
                                        viewModel.copyCodeToClipboard()
                                    }) {
                                        Label("", systemImage: "document.on.document")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundStyle(Color.brand50)
                                    }
                                    .padding(.trailing)
                                }
                            }
                    }
                    .padding(.bottom, 10)
                    
                    // isCodeCopied 상태에 따라 "복사되었어요" 텍스트 표시
                    if viewModel.isCodeCopied {
                        Text("복사되었어요.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.orange50)
                            .transition(.opacity.animation(.easeOut(duration: 0.5)))
                    }
                }
                
                Spacer()
                
                Button("전달 완료", action: {
                    // TODO: Navigation 로직 구현
                    // 어떤 로직이 들어가야 하는가?
                    // 전달 완료 하면, 메인 화면으로 이동으로 구성한다.
                    viewModel.coordinator.push(path: .babyMain)
                    
                })
                .buttonStyle(.defaultButton)
                
                Button("초대 코드 취소", action: {
                    isShowingCancelAlert = true
                })
                .buttonStyle(.outlineThirdButton)
                .alert("초대 코드를 취소할까요?", isPresented: $isShowingCancelAlert) {
                    Button("취소", role: .cancel) { }
                    Button("확인", role: .destructive) {
                        // TODO: 서버와 통신하여 초대 코드 삭제 처리
                        viewModel.coordinator.push(path: .babyMain)
                    }
                } message: {
                    Text("초대 코드를 취소하면 더 이상 사용할 수 없어요.")
                }
            }
            .backgroundPadding(.horizontal)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .padding(.bottom, 20)
    }
}

#Preview {
    // 1. 뷰모델 인스턴스 생성
    let viewModel = GuardianInvitationCodeViewModel(coordinator: BabyMoaCoordinator())
    
    // 2. 뷰모델의 `generatedInvitation` 속성에 목업 데이터 설정
    // GuardianInvitate.mockGuardianInvitateModel의 첫 번째 요소를 사용합니다.
    viewModel.generatedInvitation = GuardianInvitate.mockGuardianInvitateModel.first
    
    // 3. 설정된 뷰모델을 뷰에 전달
    return GuardianCodeView(viewModel: viewModel)
}


