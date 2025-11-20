//
//  TextFieldStyles.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import Foundation
import SwiftUI

/**
 * struct BasicTextFieldStyle
 * 기본적인 폼 입력을 위한 텍스트 필드 스타일.
 * bgColor와 keyboardType을 파라미터로 받아 커스텀할 수 있습니다.
 */
struct BasicTextFieldStyle: TextFieldStyle {
    
    var bgColor: Color = Color.gray.opacity(0.5)
    var keyboardType: UIKeyboardType = .default
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 14))
            .padding()
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .keyboardType(keyboardType)
            .textInputAutocapitalization(.never)
    }
}


// 'brand50', 'gray90', 'gray70' 등은 Assets에 정의된 커스텀 색상이어야 합니다.

extension TextFieldStyle where Self == BasicTextFieldStyle {
    
    // --- BasicTextFieldStyle 기반 스타일 ---
    
    /// 아기 이름처럼 일반 텍스트를 입력받는 폼 스타일
    static var basicForm: BasicTextFieldStyle {
        BasicTextFieldStyle(bgColor: Color.gray90) //
    }
    
    /// 이메일 입력을 위한 폼 스타일
    static var emailForm: BasicTextFieldStyle {
        BasicTextFieldStyle(bgColor: Color.brand50, keyboardType: .emailAddress) //
    }
    
//     /// Invitation Code 입력을 위한 폼 스타일
//     static var invitationForm: BasicTextFieldStyle {
//         BasicTextFieldStyle(bgColor: .white)
//     }
}

// MARK: - Border  태두리 있는 TextField 정의

struct BorderedTextFieldStyle: TextFieldStyle {
    
    var bgColor: Color = .white
    var keyboardType: UIKeyboardType = .default
    var borderColor: Color = .gray // (gray70 대신)
    var textcolor: Color = .black
    var borderWidth: CGFloat = 1.5
    var kerning: CGFloat?
    var textAlignment: TextAlignment = .center
    var fontWeight: Font.Weight = .regular // 👈 요청사항: 프로퍼티 추가 (기본값 .regular)
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 18))
            .fontWeight(fontWeight) // 👈 요청사항: .bold 하드코딩 대신 변수 사용
            .padding()
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .keyboardType(keyboardType)
            .textInputAutocapitalization(.never)
            .foregroundStyle(textcolor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .kerning(kerning ?? 0)
            .multilineTextAlignment(textAlignment)
    }
}

extension TextFieldStyle where Self == BorderedTextFieldStyle {
    
    /// 흰색 배경, 회색 테두리의 기본 테두리 폼 (이제 기본값 .regular 적용)
    static var borderedForm: BorderedTextFieldStyle {
        BorderedTextFieldStyle(
            bgColor: .white,
            borderColor: .gray70, //
            borderWidth: 1.5
        )
        
    }
    
    /// 회색 배경, 브랜드색 테두리의 폼 (이제 기본값 .regular 적용)
    static var borderedBrandForm: BorderedTextFieldStyle {
        BorderedTextFieldStyle(
            bgColor: Color.gray90, // (gray90 대신)
            borderColor: Color.brand50, // (brand50 대신)
            borderWidth: 2
        )
    }
    
    /// 하얀색 배경, 오랜지색 테두리의 폼 (이제 기본값 .regular 적용)
    static var borderedBrandLightForm: BorderedTextFieldStyle {
        BorderedTextFieldStyle(
            bgColor: .white,
            borderColor: Color.brandLight,
            borderWidth: 1,
            fontWeight: .regular
        )
    }
    
    /// 👈 [예시 추가] fontWeight를 .bold로 명시적으로 설정한 폼
    static var borderedBoldForm: BorderedTextFieldStyle {
        BorderedTextFieldStyle(
            bgColor: .white,
            borderColor: .gray,
            borderWidth: 1.5,
            fontWeight: .bold // 👈 .bold로 명시적 설정
        )
    }
}

#Preview {
    // #Preview에서 @State를 사용하려면 임시 Wrapper View가 필요합니다.
    struct PreviewWrapper: View {
        @State private var text1: String = ""
        @State private var text2: String = ""
        @State private var text3: String = "" // invitationForm용 (현재 주석 처리됨)
        @State private var text4: String = ""
        @State private var text5: String = ""
        @State private var text6: String = "" // borderedBrandLightForm용
        @State private var text7: String = "" // 👈 borderedBoldForm 예시용
        
        // Assets 색상이 없으므로 임시 색상을 정의합니다.
        let gray50 = Color.gray.opacity(0.5)
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("BasicTextFieldStyle (테두리 없음)")
                        .font(.headline)
                        .padding(.top)

                    TextField("", text: $text1, prompt: Text("basicForm").foregroundStyle(gray50))
                        .textFieldStyle(.basicForm)

                    TextField("", text: $text2, prompt: Text("emailForm").foregroundStyle(gray50))
                        .textFieldStyle(.emailForm)
                    
                    Divider()
                        .padding(.vertical)
                    
                    Text("BorderedTextFieldStyle (테두리 있음)")
                        .font(.headline)

                    TextField("", text: $text4,
                              prompt: Text("borderedForm (이제 .regular)").foregroundStyle(.gray)
                    )
                        .textFieldStyle(.borderedForm)
                    
                    
                    TextField("", text: $text5, prompt: Text("borderedBrandForm (이제 .regular)").foregroundStyle(.gray))
                        .textFieldStyle(.borderedBrandForm)
                    
                    TextField("", text: $text6, prompt: Text("borderedBrandLightForm (이제 .regular)").foregroundStyle(.black))
                        .textFieldStyle(.borderedBrandLightForm)
                    
                    TextField("", text: $text7, prompt: Text("borderedBoldForm (명시적 .bold)").foregroundStyle(.gray))
                        .textFieldStyle(.borderedBoldForm)
                }
                .padding()
            }
        }
    }
    
    // Assets 색상이 없다는 경고를 피하기 위해 임시로 .gray 등을 사용했습니다.
    // 실제 프로젝트에서는 .brand50 등이 정의되어 있으므로 경고가 없을 것입니다.
    return PreviewWrapper()
}
