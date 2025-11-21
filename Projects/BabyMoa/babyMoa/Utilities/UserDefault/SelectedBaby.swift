//
//  SelectedBaby.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

struct SelectedBaby {
    @UserDefault(key: "babyId", defaultValue: nil)
    static var babyId: Int?
}
