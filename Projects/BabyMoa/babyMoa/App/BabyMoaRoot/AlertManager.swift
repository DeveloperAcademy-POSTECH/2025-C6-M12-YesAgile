
//
//  AlertManager.swift
//  babyMoa
//
//  Created by Baba on 11/6/25.
//

import Foundation
import SwiftUI

class AlertManager: ObservableObject {
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""

    func showAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
}
