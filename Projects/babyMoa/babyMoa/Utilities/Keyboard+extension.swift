//
//  Keyboard+extension.swift
//  babyMoa
//
//  Created by Baba on 11/19/25.
//

import Foundation
import SwiftUI

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}

