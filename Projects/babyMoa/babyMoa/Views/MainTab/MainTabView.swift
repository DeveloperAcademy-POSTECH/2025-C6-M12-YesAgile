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
        
        VStack(spacing: 0) {

            MainTopNavigtaionView(
                babyName: viewModel.selectedBaby?.name ?? "아기 선택",
                babyImage: viewModel.selectedBaby?.profileImageUrl,
                buttonType: .none
            ) {
                viewModel.showBabyListSheet()
            }
            TabView(selection: $selectedTab) {
                // 성장 탭
                GrowthView(coordinator: viewModel.coordinator)
                    .tabItem {
                        Image(systemName: "book.pages.fill")
                        Text("성장")
                    }
                    .tag(0)
                
                JourneyView(coordinator: viewModel.coordinator)
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("여정")
                    }
                    .tag(1)
                // 아기 탭
                BabyMainView(viewModel: babyMainViewModel, coordinator: viewModel.coordinator)
                    .tabItem {
                        Image(systemName: "gift.fill")
                        Text("아기")
                    }
                    .tag(2)
            }
            .tint(.orange50)  // 선택된 탭 색상
            // 탭바 배경이 상황 따라 투명/유리로 바뀌지 않도록 "항상 보이게"
            .toolbarBackground(.visible, for: .tabBar)
            // 시스템 배경색을 강제 (유리감/플로팅 인상 제거)
            .toolbarBackground(Color.white, for: .tabBar)
            //  Sheet View을 통해서 ListView가 올라와야 한다.
            .sheet(isPresented: $viewModel.isShowingSheet) {
                BabyListView(babies: viewModel.babies, onSelectBaby: { baby in
                    viewModel.selectBaby(baby)
                }, onAddBaby: {
                    viewModel.coordinator.push(path: .addBaby)
                    viewModel.isShowingSheet = false
                })
                .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                    if newHeight > 0 {
                        self.sheetHeight = newHeight
                        print("Calculated sheet height: \(newHeight)")
                    }
                }
                .presentationDetents(
                    sheetHeight > 0 ? [.height(sheetHeight)] : [.medium]
                )
                .presentationCornerRadius(25)
                .presentationDragIndicator(.visible)
            }
        }
    }
}


// MARK: - Baby Selection Header

#Preview {
    @Previewable @StateObject var coordinator = BabyMoaCoordinator()
    MainTabView(coordinator: coordinator)
}
