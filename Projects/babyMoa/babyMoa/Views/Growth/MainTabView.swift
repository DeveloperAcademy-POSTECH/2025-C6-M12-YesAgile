//
//  MainTabView.swift
//  BabyMoaMap
//
//  메인 탭바 - 성장/추억/아기 화면 전환
//

import SwiftUI

/// https://huisoo.tistory.com/30 탭바참고
/// 앱의 메인 탭바 네비게이션
/// - 성장: 아기 성장 기록 -> 추억 탭으로
/// - 추천: 바바가 주시면 붙이기
/// - 아기: 아기 설정 및 정보
struct MainTabView: View {
    @State private var selectedTab = 1  // 기본값: 추억 탭

    var body: some View {
        TabView(selection: $selectedTab) {
            // 성장 탭
            GrowthView()
                .tabItem {
                    Image(systemName: "pencil.and.ruler.fill")
                    Text("추억")
                }
                .tag(0)

            // 바바가 주시면 붙이는 추천 탭 이미지도 수정하기
            //            MemoryView()
            //                .tabItem {
            //                    Image(systemName: "photo.on.rectangle.angled")
            //                    Text("추천")
            //                }
            //                .tag(1)

            // 아기 탭
            BabyView()
                .tabItem {
                    Image(systemName: "face.smiling")
                    Text("아기")
                }
                .tag(2)

            VStack {
                Text("Additional Tab")

            }

        }
        .tint(Color("Brand-50"))  // 선택된 탭 색상
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
    MainTabView()
}
