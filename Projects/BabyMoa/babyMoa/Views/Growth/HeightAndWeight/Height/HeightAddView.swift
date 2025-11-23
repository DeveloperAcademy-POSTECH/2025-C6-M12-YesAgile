//
//  HeightAddView.swift
//  BabyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct HeightAddView: View {
    
    @StateObject private var viewModel: HeightAddViewModel
    
    // 키 TextField용 포커스 상태
    @FocusState private var isFocused: Bool
    
    // 스크롤 타겟 ID (저장 버튼이 보이도록 함)
    private let saveButtonId = "saveButton"
    
    init(coordinator: BabyMoaCoordinator, babyId: Int) {
        _viewModel = StateObject(wrappedValue: HeightAddViewModel(coordinator: coordinator, babyId: babyId))
    }
    
    var body: some View {
        ZStack {
            // ✅ 배경만 SafeArea 무시
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 상단 네비게이션 바
                CustomNavigationBar(title: "키 기록", leading: {
                    Button {
                        viewModel.coordinator.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                })
                
                // ✅ ScrollViewReader로 자동 스크롤
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            
                            // MARK: - 측정일
                            VStack(alignment: .leading, spacing: 8) {
                                Text("측정일")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.black)
                                
                                Button {
                                    viewModel.showDatePicker = true
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text(viewModel.measuredDate, formatter: DateFormatter.yyyyMMdd)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color("Font"))
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.outlineMileButton)
                            }
                            
                            // MARK: - 키
                            VStack(alignment: .leading, spacing: 8) {
                                Text("키")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.black)
                                
                                Button {
                                    // TODO: 직접 입력 액션 필요 시 추가
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text("\(String(format: "%.1f", viewModel.heightValue)) cm")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color("Font"))
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.outlineMileButton)
                            }
                            
                            // MARK: - 눈금 + 슬라이더
                            HorizontalDialPicker(
                                value: $viewModel.heightValue,
                                range: viewModel.minHeight...viewModel.maxHeight,
                                step: 0.1
                            )
                            
                            // MARK: - 메모
                            MemoTextEditor(
                                memo: $viewModel.memo,
                                limit: 300,
                                isFocused: $isFocused
                            )
                            
                            // 여유 공간
                            Spacer(minLength: 0)
                            
                            // MARK: - 저장 버튼 (자동 스크롤 타깃)
                            Button("저장") {
                                Task { await viewModel.saveHeight() }
                            }
                            .buttonStyle(.defaultButton)
                            .id(saveButtonId) // ✅ scrollTo 타깃
                        }
                        // ✅ 키보드 위로 내용이 충분히 올라오도록 하단 여유
                        .padding(.bottom, 44)
                    }
                    .scrollIndicators(.hidden)
                    .scrollDismissesKeyboard(.interactively) // 스크롤하며 키보드 내리기
                    
                    // ✅ 메모에 포커스가 생기면 저장 버튼이 보이도록 아래로 스크롤
                    .onChange(of: isFocused) { focused in
                        guard focused else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                proxy.scrollTo(saveButtonId, anchor: .bottom)
                            }
                        }
                    }
                    
                    // 오류 알럿
                    .alert(
                        "오류",
                        isPresented: Binding(
                            get: { viewModel.errorMessage != nil },
                            set: { _ in viewModel.errorMessage = nil }
                        )
                    ) {
                        Button("확인") { }
                    } message: {
                        Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.")
                    }
                }
            }
            .backgroundPadding(.horizontal)
            .padding(.bottom, 44)
            // ✅ 아무데나 탭해도 키보드 내리기 (버튼 동작 방해 X)
            .simultaneousGesture(
                TapGesture().onEnded { isFocused = false }
            )
            
            // 날짜 피커 모달
            if viewModel.showDatePicker {
                DatePickerModal(
                    birthDate: $viewModel.measuredDate,
                    showDatePicker: $viewModel.showDatePicker,
                    style: .graphical,
                    components: .date
                )
            }
        }
        // ✅ 상단만 SafeArea 무시 (키보드 회피 유지)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    HeightAddView(coordinator: BabyMoaCoordinator(), babyId: 1)
}
