//
//  ResponseModelable.swift
//  BabyMoa
//
//  Created by 한건희 on 11/7/25.
//

import SwiftUI

protocol ResponseModelable: Decodable {
    associatedtype DomainType: Entity
    func toDomain() async -> DomainType
}
