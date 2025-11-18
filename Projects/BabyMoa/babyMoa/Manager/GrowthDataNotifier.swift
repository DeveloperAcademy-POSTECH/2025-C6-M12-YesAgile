//
//  GrowthDataNotifier.swift
//  BabyMoa
//
//  Created by Baba on 11/19/25.
//

import Combine

final class GrowthDataNotifier {
    static let shared = GrowthDataNotifier()
    private init() {}
    
    let heightDidUpdate = PassthroughSubject<Void, Never>()
    let weightDidUpdate = PassthroughSubject<Void, Never>()
}
