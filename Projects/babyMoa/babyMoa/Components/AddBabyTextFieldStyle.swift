//
//  AddBabyTextFieldStyle.swift
//  babyMoa
//
//  Created by Baba on 10/20/25.
//

import Foundation
import SwiftUI

struct AddBabyTextFieldStyle: TextFieldStyle {
    
    var bgColor: Color = .gray.opacity(0.5)
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 14))
            .padding()
            .background(bgColor.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
    }
}
