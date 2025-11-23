//
//  MainTabView.swift
//  BabyMoaMap
//
//
//

import SwiftUI

struct MainTabView: View {
    @State var viewModel: MainTabViewModel
    @StateObject var babyMainViewModel: BabyMainViewModel
    
    @State private var selectedTab = 0
    @State private var sheetHeight: CGFloat = 0
    
    init(coordinator: BabyMoaCoordinator) {
        _viewModel = State(wrappedValue: MainTabViewModel(coordinator: coordinator))
        _babyMainViewModel = StateObject(wrappedValue: BabyMainViewModel(coordinator: coordinator))
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            GrowthView(coordinator: viewModel.coordinator)
                .tabItem { Image(systemName: "book.pages.fill"); Text("성장") }
                .tag(0)
                .padding(.top, 60)
                .background(Color.background)

            JourneyMainView(coordinator: viewModel.coordinator)
                .tabItem { Image(systemName: "hand.thumbsup.fill"); Text("추천") }
                .tag(1)
                .padding(.top, 60)
                .background(Color.background)


            BabyMainView(viewModel: babyMainViewModel, coordinator: viewModel.coordinator)
                .tabItem { Image(systemName: "gift.fill"); Text("아기") }
                .tag(2)
                .padding(.top, 60)
                .background(Color.background)

        }
        .tint(.orange50)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.white, for: .tabBar)

        // ✅ 시스템 NavigationBar를 완전히 숨겨 '띠' 제거
        .toolbar(.hidden, for: .navigationBar)

        // 커스텀 상단 헤더를 안전영역에 꽂기
        .safeAreaInset(edge: .top) {
            MainTopNavigtaionView(
                babyName: viewModel.selectedBaby?.name ?? "아기 선택",
                babyImage: viewModel.selectedBaby?.profileImageUrl,
                buttonType: .none
            ) {
                viewModel.showBabyListSheet()
            }
            .background(Color.background)
            .padding(.vertical, 0)
        }

        .sheet(isPresented: $viewModel.isShowingSheet) {
            BabyListView(
                babies: viewModel.babies,
                onSelectBaby: { baby in viewModel.selectBaby(baby) },
                onAddBaby: {
                    viewModel.coordinator.push(path: .addBaby)
                    viewModel.isShowingSheet = false
                }
            )
            .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                if newHeight > 0 { sheetHeight = newHeight }
            }
            .presentationDetents(sheetHeight > 0 ? [.height(sheetHeight)] : [.medium])
            .presentationCornerRadius(25)
            .presentationDragIndicator(.visible)
        }
        .onAppear { Task { await viewModel.fetchBabies() } }
    }
}

#Preview {
    @Previewable @StateObject var coordinator = BabyMoaCoordinator()
    MainTabView(coordinator: coordinator)
}
