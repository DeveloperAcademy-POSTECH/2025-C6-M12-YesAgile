//
//  MainTabView.swift
//  BabyMoaMap
//
//
//

import SwiftUI

struct MainTabView: View {
    @State var viewModel: MainTabViewModel
    @State private var selectedTab = 0  // 기본값: 추억 탭
    
    init(coordinator: BabyMoaCoordinator) {
        viewModel = MainTabViewModel(coordinator: coordinator)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // 성장 탭
            GrowthView(coordinator: viewModel.coordinator)
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("성장")
                }
                .tag(0)
            EmptyView()
                .tag(1)
            // 아기 탭
//            BabyMainView()
//                .tabItem {
//                    Image(systemName: "gift.fill")
//                    Text("아기")
//                }
//                .tag(2)
        }
        .tint(.brand50)  // 선택된 탭 색상
        // 탭바 배경이 상황 따라 투명/유리로 바뀌지 않도록 "항상 보이게"
        .toolbarBackground(.visible, for: .tabBar)
        // 시스템 배경색을 강제 (유리감/플로팅 인상 제거)
        .toolbarBackground(Color(.systemBackground), for: .tabBar)
    }
}

// MARK: - Baby Selection Header

/// 상단 아기 선택 헤더
struct BabySelectionHeader: View {
    @State private var showBabySelection = false

    var body: some View {
        HStack(spacing: 12) {
            // 아기 프로필 이미지
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "face.smiling")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                )

            // 아기 이름 + 드롭다운 버튼
            Button(action: {
                showBabySelection.toggle()
            }) {
                HStack(spacing: 4) {
                    Text("아기")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("Font"))

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("Font"))
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .actionSheet(isPresented: $showBabySelection) {
            ActionSheet(
                title: Text("아기 선택"),
                buttons: [
                    .default(Text("아기 이름")) {},
                    .default(Text("+ 아기 추가")) {},
                    .cancel(),
                ]
            )
        }
    }
}
// MARK: - Preview

#Preview {
    @Previewable @StateObject var coordinator = BabyMoaCoordinator()
    MainTabView(coordinator: coordinator)
}
