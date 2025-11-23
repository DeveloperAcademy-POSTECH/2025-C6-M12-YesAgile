//
//  PermissionModal.swift
//  BabyMoa
//
//  Created by 한건희 on 11/23/25.
//

import SwiftUI

struct PermissionModal: View {
    @Binding var isPresented: Bool

    @State private var animateIn: Bool = false   // 등장 애니메이션
    @State private var animateOut: Bool = false  // 퇴장 애니메이션

    var body: some View {
        if isPresented || animateOut {
            ZStack {
                // 배경 dim
                Color.black.opacity(animateIn ? 0.35 : 0)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.25), value: animateIn)
                    .onTapGesture {
                        close()
                    }

                // 모달 카드
                VStack(spacing: 20) {
                    Text("사진 라이브러리 권한허용을 위해\n설정으로 이동하세요.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.horizontal)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                        .frame(height: 100)
                        
                    HStack(spacing: 15) {
                        Button(action: {
                            close()
                        }) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white)
                                .frame(maxWidth: 100, maxHeight: 45)
                                .overlay(
                                    Text("취소")
                                        .foregroundStyle(.accent)
                                )
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: {
                            openSettings()
                        }) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.accent)
                                .frame(maxWidth: 100, maxHeight: 45)
                                .overlay(
                                    Text("이동")
                                        .foregroundStyle(.white)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 10)
                .frame(maxWidth: 300)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(.systemBackground))
                )
                .scaleEffect(animateIn ? 1.0 : 0.85)
                .opacity(animateIn ? 1.0 : 0.0)
                .offset(y: animateIn ? 0 : 60)
                .shadow(color: .black.opacity(0.1), radius: 15)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: animateIn)
            }
            .onAppear {
                animateIn = true
            }
        }
    }

    // MARK: - Close handling
    private func close() {
        animateIn = false
        animateOut = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isPresented = false
            animateOut = false
        }
    }

    // MARK: - Open Settings
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    @Previewable @State var isPresented = true
    PermissionModal(isPresented: $isPresented)
}
