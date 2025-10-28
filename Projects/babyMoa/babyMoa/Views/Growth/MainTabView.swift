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
        .tint(Color("BrandPrimary"))  // 선택된 탭 색상
        // 탭바 배경이 상황 따라 투명/유리로 바뀌지 않도록 "항상 보이게"
        .toolbarBackground(.visible, for: .tabBar)
        // 시스템 배경색을 강제 (유리감/플로팅 인상 제거)
        .toolbarBackground(Color(.systemBackground), for: .tabBar)
    }
}

// MARK: - Memory View (추억 - 현재 메인 화면)
// Note: GrowthView는 Views/Growth/GrowthView.swift에 구현되어 있습니다

//struct MemoryView: View {
//    var body: some View {
//        VStack(spacing: 0) {
//            // 상단 헤더 (아기 선택)
//            BabySelectionHeader()
//
//            // 기존 ContentView 내용 (캘린더 + 지도)
//            MemoryContentView()
//        }
//    }
//}

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
                        .foregroundColor(Color("TextPrimary"))

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("TextPrimary"))
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

// MARK: - Memory Content View

/// 추억 화면의 메인 컨텐츠 (캘린더 + 지도)
//struct MemoryContentView: View {
//    @State private var viewModel = PhotoViewModel()
//    @State private var showAddMemory = false
//    @State private var showMemoryList = false
//    @State private var selectedDateForMemory: Date = Date()
//
//    var body: some View {
//        @Bindable var viewModel = viewModel
//
//        ScrollView {
//            VStack(spacing: 16) {
//                // 캘린더 카드
//                CalendarCard(
//                    selectedDate: $viewModel.selectedDate,
//                    photos: viewModel.photos
//                ) { date in
//                    selectedDateForMemory = date
//                    // 해당 날짜의 추억이 있는지 확인
//                    let memoriesForDate = getMemories(
//                        for: date,
//                        from: viewModel.photos
//                    )
//                    if memoriesForDate.isEmpty {
//                        showAddMemory = true
//                    } else {
//                        showMemoryList = true
//                    }
//                }
//
//                // 지도 카드
//                CompactMapCard(
//                    photos: $viewModel.photos,
//                    currentLocation: viewModel.currentLocation
//                )
//                .frame(height: 400)  // 고정 높이
//
//                Spacer(minLength: 20)
//            }
//            .padding(.bottom, 20)  // 탭바 공간 확보
//        }
//        .scrollIndicators(.hidden)
//        .background(Color(.systemGroupedBackground))
//        .fullScreenCover(isPresented: $showAddMemory) {
//            AddMemoryView(selectedDate: selectedDateForMemory) {
//                image,
//                memo,
//                date in
//                // 사진 저장 로직
//                viewModel.addPhoto(image: image, memo: memo, date: date)
//            }
//        }
//        .fullScreenCover(isPresented: $showMemoryList) {
//            let memoriesForDate = getMemories(
//                for: selectedDateForMemory,
//                from: viewModel.photos
//            )
//            AddMemoryListView(
//                selectedDate: selectedDateForMemory,
//                memories: memoriesForDate
//            ) { image, memo, date in
//                // 추가 사진 저장 로직
//                viewModel.addPhoto(image: image, memo: memo, date: date)
//            }
//        }
//    }

// MARK: - Helper
//
//    private func getMemories(for date: Date, from photos: [LocalPhoto])
//        -> [LocalPhoto]
//    {
//        let calendar = Calendar.current
//        return photos.filter { photo in
//            calendar.isDate(photo.date, inSameDayAs: date)
//        }
//    }
//}

// MARK: - Preview

#Preview {
    MainTabView()
}
