//
//  EndPoint.swift
//  babyMoa
//
//  Created by 한건희 on 10/30/25.
//

//
//  EndPoint.swift
//  Woorinara
//
//  Created by 한건희 on 1/23/25.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var query: [String: String]? { get }
    var body: [String: Any?]? { get }
}

extension Endpoint {
    var scheme: String {
        return "http"
    }
    
    var host: String {
//        return "yesagile.shop"
        return "localhost"
    }
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case failureWithString(String)
    case unexpectedStatusCode
    case unknown

    var message: String {
        switch self {
        case .decode:
            return "Decode Error"
        case .invalidURL:
            return "Session expired"
        case .noResponse:
            return "noResponse"
        case .unauthorized:
            return "unauthorized"
        case .failureWithString(let failureString):
            return failureString
        case .unexpectedStatusCode:
            return "unexpected"
        case .unknown:
            return "unknown"
        }
    }
}
