//
//  BabyMoaRootViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/1/25.
//

import SwiftUI

final class BabyMoaRootViewModel: ObservableObject {
    func isUserAuthorized() -> Bool {
        if UserToken.accessToken == "" {
            return false
        }
        return true
    }
}
