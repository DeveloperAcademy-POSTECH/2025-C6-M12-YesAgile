//
//  WeightAddView.swift
//  BabyMoa
//
//  Created by Baba on 11/13/25.
//

import SwiftUI

struct WeightAddView: View {
    
    @StateObject private var viewModel: WeightAddViewModel // ViewModel 사용

    // 메모 TextEditor 포커스 상태
    @FocusState private var isFocused: Bool
    
    init(coordinator: BabyMoaCoordinator, babyId: Int) {
        _viewModel = StateObject(wrappedValue: WeightAddViewModel(coordinator: coordinator, babyId: babyId))
    }

    var body: some View {
        ZStack {
            Color.background
               
            VStack(spacing: 0) {
                
                // 상단 네비게이션 바
                CustomNavigationBar(title: "몸무게 기록", leading: {
                    
                    
                    Button(action:  {
                        viewModel.coordinator.pop() // 뒤로가기 액션 구현
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                })

                VStack(alignment: .leading, spacing: 24) { // spacing 24로 변경
                    
                    // MARK: - 측정일
                    VStack(alignment: .leading, spacing: 8) {
                        Text("측정일")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.black)

                        Button(action: {
                            viewModel.showDatePicker = true // ViewModel의 프로퍼티 사용
                        }, label: {
                            HStack {
                                Spacer()

                                Text(viewModel.measuredDate, formatter: DateFormatter.yyyyMMdd) // ViewModel의 프로퍼티 사용
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("Font"))

                                Spacer()
                            }
                        })
                        .buttonStyle(.outlineMileButton)
                    }

                    // MARK: - 몸무게
                    VStack(alignment: .leading, spacing: 8) {
                        Text("몸무게") // "키" -> "몸무게"로 수정
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.black)
                        
                        Button(action: {
                            // TODO: 몸무게 직접 입력용 액션 (Alert / Sheet 등)
                            // 현재는 HorizontalDialPicker와 연결되어 있으므로, 필요시 여기에 추가 로직 구현
                        }, label: {
                            HStack {
                                Spacer()
                                Text("\(String(format: "%.1f", viewModel.weightValue)) kg") // ViewModel의 프로퍼티 사용
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("Font"))
                                Spacer()
                                
                            }
                        })
                        .buttonStyle(.outlineMileButton)
                    }
                    
                    // MARK: - 눈금 + 슬라이더
                    HorizontalDialPicker(
                        value: $viewModel.weightValue, // ViewModel의 프로퍼티에 바인딩
                        range: viewModel.minWeight...viewModel.maxWeight, // ViewModel의 프로퍼티 사용
                        step: 0.1
                    )
                    
                    // MARK: - 메모
                    MemoTextEditor(
                        memo: $viewModel.memo, // ViewModel의 프로퍼티에 바인딩
                        limit: 300,
                        isFocused: $isFocused
                    )

                    Spacer()
                }
                
                Button("저장", action: {
                    Task {
                        await viewModel.saveWeight() // ViewModel의 saveWeight() 호출
                    }
                })
                .buttonStyle(.defaultButton)
                .alert("오류", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
                    Button("확인") { }
                } message: {
                    Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.")
                }
                
            }
            .backgroundPadding(.horizontal)
            .padding(.bottom, 44)
            .simultaneousGesture(   // ✅ 버튼 동작 + 키보드 내리기 둘 다 가능
                TapGesture().onEnded {
                    isFocused = false
                }
            )
            
            // 날짜 피커 모달
            if viewModel.showDatePicker { // ViewModel의 프로퍼티 사용
                DatePickerModal(
                    birthDate: $viewModel.measuredDate, // ViewModel의 프로퍼티 사용
                    showDatePicker: $viewModel.showDatePicker, // ViewModel의 프로퍼티 사용
                    style: .graphical,
                    components: .date
                )
            }
        }
        .ignoresSafeArea()
    }
    
}



#Preview {
    WeightAddView(coordinator: BabyMoaCoordinator(), babyId: 1) // Preview에서도 babyId 전달
}
