//
//  babyMoaTests.swift
//  babyMoaTests
//
//  Created by keonheehan on 10/30/25.
//

import Testing
@testable import babyMoa

struct babyMoaTests {

    @Test func login() async {
        let idToken = "eyJraWQiOiJZUXJxZE1ENGJxIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLmtlb25oZWVoYW4uQXBwbGVMb2dpblRlZXN0IiwiZXhwIjoxNzYxODc1MjgyLCJpYXQiOjE3NjE3ODg4ODIsInN1YiI6IjAwMDgwMS45NTg4NjA3NzMyMTg0OWM0YjgzOWVhNGFkYWFjZmZhMy4wNzIyIiwiY19oYXNoIjoiWG12c01lUTRmcHNOUy1YRm5zdmQyQSIsImVtYWlsIjoia2VvbmhlZWhhbkBuYXZlci5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXV0aF90aW1lIjoxNzYxNzg4ODgyLCJub25jZV9zdXBwb3J0ZWQiOnRydWV9.dEeX49Z7pdwBBFIKhUqqaRKwUyYSgnnCZ-NXUKyyCK6f2hwUuHUNmGTXQZFqW8p309Wxmnc-3jztgNzTmjB24J0J0hZzMfkO6s-F_bI4zLPl0reitIh0fCnN1k-YNagp07VPwtv0cbhlFLaQ9Wng6eynzJa_cZoVMeSDEKRIEAh3yz6sR9myfSZgD5Z-4hh7M9Ce5wrLE0ppGdnaTYuUFu1uLQgv8bTtKj_VY-rdGHxCzOrCSfJPZXsTClWKmgENEtFEVulY98LrPf2eFpzIWHfdtfozwZ6zbtLoitG-lGnaO165qgUtBLxzLgPw-i8trBrgqeyihbPw1TVskMeUfQ"
        let result = await BabyMoaService.shared.postAppleLogin(idToken: idToken)
        
        switch result {
        case .success(let success):
            if let loginResModel = success.data {
                print("accessToken: \(loginResModel.accessToken)")
                print("refreshToken: \(loginResModel.refreshToken)")
                print("tokenType: \(loginResModel.tokenType)")
            }
            
        case .failure(let failure):
            print(failure)
        }
    }

}
