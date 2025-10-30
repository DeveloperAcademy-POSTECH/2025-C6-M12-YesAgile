//
//  BabyMoaEndPoint.swift
//  babyMoa
//
//  Created by keonheehan on 10/30/25.
//

enum BabyMoaEndpoint: Endpoint {
    case appleLogin(idToken: String)
}

extension BabyMoaEndpoint {
    
    var path: String {
        switch self {
        case .appleLogin:
            return "/api/auth/apple/login"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .appleLogin:
            return .post
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .appleLogin:
            return [
                "accept": "*/*",
                "Content-Type": "application/json"
            ]
        default:
            return nil
        }
    }
    
    var query: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
    
    var body: [String : Any?]? {
        switch self {
        case .appleLogin(let idToken):
            return [
                "idToken": idToken
            ]
        default:
            return nil
        }
    }
}
