//
//  ButtonStyles.swift
//  babyMoa
//
//  Created by Baba on 10/31/25.
//

import SwiftUI

struct GenderSelectButtonStyle: ButtonStyle {
    var selectedGender: String
    var value: String

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(selectedGender == value ? Color.brand50: Color.gray50)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(selectedGender == value ? Color.brand40.opacity(0.1) : Color.clear)
            .contentShape(Rectangle())
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(selectedGender == value ? Color.brand50 : Color.gray50, lineWidth: 1.5)
            )
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct DateSelectButtonStyle: ButtonStyle{
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color("Gray80")) //
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.8 : 1.0)

    }
}

//MARK: - 배경, 글꼴, 테두리, 눌림 상태를 모두 설정함

struct AppButtonStyle: ButtonStyle {
    
    // 1. 스타일 설정용 프로퍼티
    var backgroundColor: Color
    var foregroundColor: Color
    var pressedBackgroundColor: Color?
    
    var borderColor: Color = .clear
    var borderWidth: CGFloat = 0
    var pressedOpacity: CGFloat? = 0.8
    
    var fontSize: CGFloat?
    var fontWeight: Font.Weight?
    
    var height: CGFloat? = nil
    
    
    
    // 2. _body 함수
    func makeBody(configuration: Configuration) -> some View {
        let currentOpacity = (pressedOpacity != nil && configuration.isPressed) ? pressedOpacity! : 1.0
        let bgColor = configuration.isPressed ? (pressedBackgroundColor ?? backgroundColor) : backgroundColor
        
        configuration.label
            .font(.system(
                size: fontSize ?? 16,
                weight: fontWeight ?? .semibold
            ))
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(16)                 // ← 내용 padding
            .frame(height: height)       // ← 버튼 높이
            .background(                 // 🔹 배경은 background에서
                RoundedRectangle(cornerRadius: 12)
                    .fill(bgColor)
            )
            .overlay(                    // 🔹 테두리는 overlay에서
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(       // ← 가능하면 strokeBorder 사용 권장
                        borderColor,
                        lineWidth: borderColor == .clear ? 0 : borderWidth
                    )
            )
            .opacity(currentOpacity)
            .contentShape(RoundedRectangle(cornerRadius: 12))
    }
}
//MARK: - AppButtonStyle을 쉽게 사용하기 위한 extension

extension ButtonStyle where Self == AppButtonStyle {
    
    static var defaultButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .brand50,
            foregroundColor: .white,
            pressedBackgroundColor: .brand70
        )
    }
    

    static var primaryButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .orange70,
            foregroundColor: .white,
            pressedBackgroundColor: .orange70
        )
    }
    
    
    static var secondButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .orange50,
            foregroundColor: .white,
            pressedBackgroundColor: .orange70
        )
    }
    
    static var noneButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .gray90,
            foregroundColor: .gray70,
            pressedBackgroundColor: .gray90,
            pressedOpacity: nil
        )
    }
    
 
    static var outlineButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .brand40.opacity(0.1),
            foregroundColor: .brand50,
            pressedBackgroundColor: .brand40.opacity(0.1), // 눌려도 색 유지
            borderColor: .brand50, // 👈 테두리 색상 설정
            borderWidth: 1         // 👈 테두리 두께 설정
        )
    }
    
    static var outlineSecondButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .white,
            foregroundColor: .gray50,
            borderColor: .gray50, // 👈 테두리 색상 설정
            borderWidth: 1         // 👈 테두리 두께 설정
        )
    }
    
    static var outlineThirdButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .clear,
            foregroundColor: .brand50,
            borderColor: .brand50, // 👈 테두리 색상 설정
            borderWidth: 1         // 👈 테두리 두께 설정
        )
    }
    
    static var outlineFourButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .clear,
            foregroundColor: .brand50,
            borderColor: .orange70, // 👈 테두리 색상 설정
            borderWidth: 1         // 👈 테두리 두께 설정
        )
    }
    
    static var outlineDefaultButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .clear,
            foregroundColor: .font,
            borderColor: .brand40, // 👈 테두리 색상 설정
            borderWidth: 1         // 👈 테두리 두께 설정
        )
    }
    
    static var outlineMileButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .white,
            foregroundColor: .font,
            borderColor: .brandLight, // 👈 테두리 색상 설정
            borderWidth: 1         // 👈 테두리 두께 설정
        )
    }
    
    static var outlinelessButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .white,
            foregroundColor: .black,
            borderColor: .clear, // 👈 테두리 색상 설정
            borderWidth: 1,         // 👈 테두리 두께 설정
            fontSize: 14,
            fontWeight: .regular

        )
    }
    
    static var fixedHeightButton: AppButtonStyle {
        AppButtonStyle(
            backgroundColor: .brand50,
            foregroundColor: .white,
            pressedBackgroundColor: .brand70,
            height: 60

        )
    }
    
}


#Preview {
    // @State를 사용하기 위해 임시 래퍼 뷰를 만듭니다.
    struct ButtonPreviewWrapper: View {
        @State private var selectedGender = "남아"
        
        var body: some View {
            ScrollView {
                VStack(spacing: 5) {
                    
                    // --- GenderSelectButtonStyle (고유 스타일) ---
                    Text("GenderSelectButtonStyle")
                        .font(.headline)
                    HStack {
                        Button("남아") { selectedGender = "남아" }
                            .buttonStyle(GenderSelectButtonStyle(selectedGender: selectedGender, value: "남아"))
                        Button("여아") { selectedGender = "여아" }
                            .buttonStyle(GenderSelectButtonStyle(selectedGender: selectedGender, value: "여아"))
                        Button("미정") { selectedGender = "미정" }
                            .buttonStyle(GenderSelectButtonStyle(selectedGender: selectedGender, value: "미정"))
                    }
                    
                    Divider()
                    
                    // --- DateSelectButtonStyle (고유 스타일) ---
                    Text("DateSelectButtonStyle")
                        .font(.headline)
                    Button("2025년 11월 03일") { }
                        .buttonStyle(DateSelectButtonStyle())
                        .foregroundColor(.primary)

                    Divider()

                    // --- 👇 AppButtonStyle 사용 (리팩토링된 스타일) ---
                    
                    Text("DefaultButtonStyle (이제 .defaultButton)")
                        .font(.headline)
                    Button("기본 버튼 (Default)") { }
                        .buttonStyle(.defaultButton) // ✅ 훨씬 깔끔함

                    Divider()

                    Text("PrimaryButtonStyle (이제 .primaryButton)")
                        .font(.headline)
                    Button("주요 버튼 (Primary)") { }
                        .buttonStyle(.primaryButton) // ✅ 훨씬 깔끔함
                    
                    Divider()
                    
                    Text("PrimaryButtonStyle (이제 .primaryButton)")
                        .font(.headline)
                    Button("주요 버튼 (Secondary)") { }
                        .buttonStyle(.secondButton) // ✅ 훨씬 깔끔함
                    
                    Divider()

                    Text("NoneButtonStyle (이제 .noneButton)")
                        .font(.headline)
                    Button("보조 버튼 (Secondary)") { }
                        .buttonStyle(.noneButton) // ✅ 훨씬 깔끔함

                    Divider()

                    Text("OutlineButtonStyle (이제 .outlineButton)")
                        .font(.headline)
                    Button("외곽선 버튼 (Outline)") { }
                        .buttonStyle(.outlineButton) // ✅ 훨씬 깔끔함
                    
                    Divider()

                    Text("OutlineSecondButtonStyle")
                        .font(.headline)
                    Button("외곽선 버튼 (Outline)") { }
                        .buttonStyle(.outlineSecondButton) // ✅ 훨씬 깔끔함
                    
                    Divider()

                    Text("OutlineThirdButtonStyle")
                        .font(.headline)
                    Button("외곽선 버튼 (Outline)") { }
                        .buttonStyle(.outlineThirdButton) // ✅ 훨씬 깔끔함
                    
                    Divider()

                    Text("OutlineFourButtonStyle")
                        .font(.headline)
                    Button("외곽선 버튼 (Outline)") { }
                        .buttonStyle(.outlineFourButton) // ✅ 훨씬 깔끔함
                    
                    
//                    outlineMileButton
                    
                    Divider()
                    
                    Text("OutlineMileButton")
                        .font(.headline)
                    Button("외곽선 버튼 (Outline)") { }
                        .buttonStyle(.outlineMileButton) // ✅ 훨씬 깔끔함
                    
                    Divider()
                    
                    Text("OutlineDefaultButton")
                        .font(.headline)
                    Button("외곽선 버튼 (Outline)") { }
                        .buttonStyle(.outlineDefaultButton) // ✅ 훨씬 깔끔함
                    
                    Divider()

                    Text("OutlinelessButtonStyle")
                        .font(.headline)
                    Button("외곽선 버튼 (Outline)") { }
                        .buttonStyle(.outlinelessButton) // ✅ 훨씬 깔끔함
                }
                .padding()
            }
        }
    }
    
    return ButtonPreviewWrapper()
}
