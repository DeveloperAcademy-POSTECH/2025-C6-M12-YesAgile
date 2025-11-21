//
//  BaseResponse.swift
//  babyMoa
//
//  Created by keonheehan on 10/30/25.
//

struct BaseResponse<T: Decodable>: Decodable {
    var status: Int
    var message: String?
    var data: T?
}
