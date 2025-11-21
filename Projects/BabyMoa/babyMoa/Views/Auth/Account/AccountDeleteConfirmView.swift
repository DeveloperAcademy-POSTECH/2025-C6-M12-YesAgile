//
//  AccountDeleteConfirmView.swift
//  babyMoa
//
//  Created by Baba on 11/21/25.
//

import SwiftUI

struct AccountDeleteConfirmView: View {

    let coordinator: BabyMoaCoordinator

    @State private var isAgreed: Bool = false
    @State private var isLoading: Bool = false
    
    @State private var showErrorAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        ZStack {
            Color.background

            VStack(spacing: 0) {
                // MARK: - Custom Navigation Bar
                CustomNavigationBar(
                    title: "탈퇴하기",
                    leading: {
                        Button {
                            coordinator.pop()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                )
                // MARK: - Content
                ScrollView {
                    VStack(spacing: 20) {

                        // 상단 "탈퇴 전 확인" 타이틀
                        Text("탈퇴 전 확인")
                            .font(.system(size: 26, weight: .medium))
                            .foregroundStyle(.font)
                            .padding(.top, 28)

                        // 안내 박스
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color.brand50)

                                Text("다른 양육자가 없는 아기의 정보가 삭제돼요.")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.font)
                            }

                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color.brand50)

                                Text("모든 삭제된 데이터는 복구할 수 없어요.")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.font)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray90)
                        )
                    }
                }
                .scrollIndicators(.hidden)
                
                
                if isAgreed {
                    ZStack{
                        
                        Text("홍길동님을 다시 만날 수 없어 아쉬워요. 아이의 어린 시절을 붙잡을 수 없듯 홍길동님을 추억할게요.")
                            .font(.system(size: 18))
                            .lineSpacing(3)
                            .padding(15)
                            .foregroundStyle(Color.font)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                UnevenRoundedRectangle(
                                    cornerRadii: .init(
                                        topLeading: 12,
                                        bottomLeading: 12,
                                        bottomTrailing: 0,
                                        topTrailing: 12
                                    )
                                )
                                .stroke(Color.gray90, lineWidth: 1)
                            )
                            .overlay {
                                Image(.accountBird)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 92, height: 138)
                                    .offset(x: 120, y: 30) //
                            }
                     
                       

                    }
                    .padding(.bottom, 56)
                }
                
                // 체크박스 영역
                Button {
                    isAgreed.toggle()
                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Image(
                            systemName: isAgreed
                            ? "checkmark.square.fill"
                            : "square"
                        )
                        .font(.system(size: 20))
                        .foregroundStyle(
                            isAgreed ? Color.brand50 : Color.gray70
                        )

                        Text("안내사항을 모두 확인했으며, 동의합니다.")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.font)

                        Spacer()
                    }
                }
                .padding(.bottom, 20)

                // MARK: - Bottom Button
                Button {
                    Task {
                        await deleteAccount()
                    }
                } label: {
                    Text("탈퇴하기")
                }
                .buttonStyle(isAgreed ? .defaultButton : .noneButton)
                .disabled(!isAgreed || isLoading)
                .padding(.bottom, 44)
            }
            .backgroundPadding(.horizontal)
        }
        .ignoresSafeArea()
        .alert("알림", isPresented: $showErrorAlert) {
            Button("확인") {}
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - 탈퇴 처리
    @MainActor
    private func deleteAccount() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        let result = await BabyMoaService.shared.deleteAccount()
        
        // `BabyMoaService`의 `refreshToken` 함수가 전역 인증 오류를 감지하고
        // `SessionManager.signOut()`을 호출하므로, 여기서는 성공 케이스와
        // 인증 오류 외의 일반적인 실패 케이스만 처리합니다.
        switch result {
        case .success:
            // 계정 삭제 성공 시, 중앙 로그아웃 함수를 호출하여 모든 데이터를 정리하고 초기 화면으로 이동합니다.
            SessionManager.signOut()
            
        case .failure(let error):
            // 인증 오류가 아닌 다른 모든 오류에 대해 사용자에게 알림을 표시합니다.
            // (인증 오류는 BabyMoaService에서 감지하여 자동으로 signOut을 호출합니다.)
            if case .unauthorized = error {
                // 이 케이스는 BabyMoaService의 refreshToken 로직에 의해 처리되므로
                // 일반적으로 여기에 도달하지 않지만, 만약을 위해 비워둡니다.
                // 전역 핸들러가 UI를 이미 리셋했을 것입니다.
            } else {
                alertMessage = "계정 탈퇴에 실패했습니다. 네트워크 연결을 확인하고 다시 시도해 주세요."
                showErrorAlert = true
            }
        }
    }
}

#Preview {
    AccountDeleteConfirmView(coordinator: BabyMoaCoordinator())
}
