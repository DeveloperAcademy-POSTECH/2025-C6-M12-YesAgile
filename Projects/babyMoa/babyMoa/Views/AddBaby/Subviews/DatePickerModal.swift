//
//  DatePickerModal.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//


import SwiftUI

struct DatePickerModal: View {
    @Binding var birthDate: Date
    @Binding var showDatePicker: Bool

    var body: some View {
        ZStack{
            Color.black
                .opacity(0.5)
            VStack(spacing: 0){
                DatePicker("", selection: $birthDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding()
                
                Button("완료") { showDatePicker = false }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .font(.headline)
                    .background(Color.brand50)
                    .foregroundColor(.white)
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding(.horizontal, 30)
        }
        .ignoresSafeArea()
        .onTapGesture {
            showDatePicker = false
        }

        
    }
}



#Preview{
    DatePickerModal(birthDate: .constant(Date()),
                    showDatePicker: .constant(true))
}
