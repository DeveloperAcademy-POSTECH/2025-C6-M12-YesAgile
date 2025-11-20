//
//  DatePickerModal.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//


import SwiftUI

// 1. 선택 가능한 DatePicker 스타일을 Enum으로 정의합니다.
enum ModalDatePickerStyle {
    case graphical
    case wheel
}


struct DatePickerModal: View {
    @Binding var birthDate: Date
    @Binding var showDatePicker: Bool
    
    @State private var selectedDate: Date
    
    // style 프로퍼티 (기본값 .graphical)
    var style: ModalDatePickerStyle = .graphical
    // components 프로퍼티를 추가합니다.
    // 기본값을 .date로 설정합니다.
    var components: DatePickerComponents = .date
    
    init(
        birthDate: Binding<Date>,
        showDatePicker: Binding<Bool>,
        style: ModalDatePickerStyle = .graphical,
        components: DatePickerComponents = .date
    ) {
        self._birthDate = birthDate
        self._showDatePicker = showDatePicker
        self.style = style
        self.components = components
        self._selectedDate = State(initialValue: birthDate.wrappedValue)
    }

    var body: some View {
        ZStack{
            Color.black
                .opacity(0.5)
                .onTapGesture {
                    showDatePicker = false
                }
            
            VStack(spacing: 0){
                
                // @ViewBuilder를 사용하여 style과 components를 모두 적용
                DatePickerViews
                    .labelsHidden()
                    .padding()
                    .onChange(of: selectedDate) { _, newValue in
                        print("DatePicker new value: \(newValue)")
                    }
                
                
                Button(action: {
                    birthDate = selectedDate
                    showDatePicker = false
                }, label: {
                    Text("완료")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .font(.headline)
                        .background(Color.brand50)
                        .foregroundColor(.white)
                })
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding(.horizontal, 30)
        }
        .ignoresSafeArea()
    }
    
    // @ViewBuilder 프로퍼티 수정
    // style에 따라 분기하고, DatePicker에는 'components' 변수를 사용합니다.
    @ViewBuilder
    private var DatePickerViews: some View {
        switch style {
        case .graphical:
            DatePicker("", selection: $selectedDate, displayedComponents: components)
                .datePickerStyle(.graphical)
        case .wheel:
            DatePicker("", selection: $selectedDate, displayedComponents: components)
                .datePickerStyle(.wheel)
        }
    }
}



#Preview("Default (Graphical, Date)") {
    DatePickerModal(
        birthDate: .constant(Date()),
        showDatePicker: .constant(true),
        style: .graphical, // style 명시
        components: .date  // components 명시 (기본값이지만 명확성을 위해)
    )
}

#Preview("Wheel Style (Date)") {
    DatePickerModal(
        birthDate: .constant(Date()),
        showDatePicker: .constant(true),
        style: .wheel, // 👈 .wheel 스타일
        components: .date
    )
}

// 👈 5. [새로운 예시] '시간'만 선택하는 휠 모달
#Preview("Wheel Style (Time)") {
    DatePickerModal(
        birthDate: .constant(Date()),
        showDatePicker: .constant(true),
        style: .wheel, // 👈 .wheel 스타일
        components: .hourAndMinute // 👈 .hourAndMinute 컴포넌트 사용
    )
}
