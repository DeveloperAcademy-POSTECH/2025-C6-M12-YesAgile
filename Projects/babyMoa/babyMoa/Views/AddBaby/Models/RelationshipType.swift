//
//  RelationshipType.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import Foundation

enum RelationshipType: String, CaseIterable, Identifiable {
    case mom = "엄마"
    case dad = "아빠"
    case other = "기타"
    
    var id: String { self.rawValue }
}
