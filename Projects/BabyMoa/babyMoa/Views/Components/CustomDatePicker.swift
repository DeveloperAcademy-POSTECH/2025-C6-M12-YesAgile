//
//  CustomDatePicker.swift
//  babyMoa
//
//  Created by Baba on 11/13/25.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    var onConfirm: (Date) -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            VStack {
                DatePicker(
                    "날짜 선택",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding()

                Button("확인") {
                    onConfirm(selectedDate)
                    isPresented = false
                }
                .buttonStyle(.defaultButton)
                .padding()
                .padding(.bottom, 30)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .transition(.move(edge: .bottom))
        }
        .animation(.easeInOut, value: isPresented)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var date = Date()
        @State private var showPicker = true
        
        var body: some View {
            ZStack {
                Color.gray.ignoresSafeArea()
                Text("Parent View")
                
                if showPicker {
                    CustomDatePicker(
                        selectedDate: $date,
                        isPresented: $showPicker,
                        onConfirm: { newDate in
                            print("Date confirmed: \(newDate)")
                        }
                    )
                }
            }
        }
    }
    
    return PreviewWrapper()
}
