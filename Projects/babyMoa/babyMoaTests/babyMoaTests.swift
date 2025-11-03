//
//  babyMoaTests.swift
//  babyMoaTests
//
//  Created by keonheehan on 11/1/25.
//

import Testing

@testable import babyMoa

struct babyMoaTests {
    @Test func login() async {
        let idToken =
            "eyJraWQiOiJZUXJxZE1ENGJxIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLmtlb25oZWVoYW4uQXBwbGVMb2dpblRlZXN0IiwiZXhwIjoxNzYxODc1MjgyLCJpYXQiOjE3NjE3ODg4ODIsInN1YiI6IjAwMDgwMS45NTg4NjA3NzMyMTg0OWM0YjgzOWVhNGFkYWFjZmZhMy4wNzIyIiwiY19oYXNoIjoiWG12c01lUTRmcHNOUy1YRm5zdmQyQSIsImVtYWlsIjoia2VvbmhlZWhhbkBuYXZlci5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXV0aF90aW1lIjoxNzYxNzg4ODgyLCJub25jZV9zdXBwb3J0ZWQiOnRydWV9.dEeX49Z7pdwBBFIKhUqqaRKwUyYSgnnCZ-NXUKyyCK6f2hwUuHUNmGTXQZFqW8p309Wxmnc-3jztgNzTmjB24J0J0hZzMfkO6s-F_bI4zLPl0reitIh0fCnN1k-YNagp07VPwtv0cbhlFLaQ9Wng6eynzJa_cZoVMeSDEKRIEAh3yz6sR9myfSZgD5Z-4hh7M9Ce5wrLE0ppGdnaTYuUFu1uLQgv8bTtKj_VY-rdGHxCzOrCSfJPZXsTClWKmgENEtFEVulY98LrPf2eFpzIWHfdtfozwZ6zbtLoitG-lGnaO165qgUtBLxzLgPw-i8trBrgqeyihbPw1TVskMeUfQ"
        let result = await BabyMoaService.shared.postAppleLogin(
            idToken: idToken
        )

        switch result {
        case .success(let success):
            if let loginResModel = success.data {
                UserToken.accessToken = loginResModel.accessToken
                UserToken.refreshToken = loginResModel.refreshToken
            }

        case .failure(let failure):
            print(failure)
        }
    }

    @Test func registerBaby() async {
        let result = await BabyMoaService.shared.postRegisterBaby(
            alias: "테스트아기",
            name: "아아",
            birthDate: "2025-01-01",
            gender: "M",
            avatarImageName: "dfdfddfdfsd",
            relationshipType: "FATHER"
        )

        switch result {
        case .success(let success):
            print(success)
        case .failure(let error):
            print(error)
        }
    }

    @Test func getBaby() async {
        let result = await BabyMoaService.shared.getBaby(babyId: 14)
        switch result {
        case .success(let success):
            print(success)
        case .failure(let failure):
            print(failure)
        }
    }
}
@Test func setRelationshipWithBaby() async {
    print(UserToken.accessToken)
    let result = await BabyMoaService.shared.postSetRelationshipWithBaby(
        babyId: 3,
        relationshipType: "MOTHER"
    )

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}
@Test func setTeethStatus() async {
    let result = await BabyMoaService.shared.postSetTeethStatus(
        babyId: 13,
        teethId: 0,  // 0~19, 윗니 10, 아랫니 10 왼쪽 -> 오른쪽
        date: "2025-01-01",
        deletion: false  // false 이여야 난거임 true 는 삭제
    )
    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}
@Test func getGrowthData() async {
    let result = await BabyMoaService.shared.getGetGrowthData(
        babyId: 6
    )
    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}

@Test func registerBabyByCode() async {

    let result = await BabyMoaService.shared.postRegisterBabyByCode(
        babyCode: "9007199254740123",
    )

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}

@Test func getBabyList() async {

    let result = await BabyMoaService.shared.getGetBabyList()

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}
@Test func setWeight() async {

    let result = await BabyMoaService.shared.postSetWeight(
        babyId: 6,  // 처음에 발급되는거 체크하고 해야함
        weight: 10,
        date: "2025-11-02"
    )

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}

@Test func setHeight() async {

    let result = await BabyMoaService.shared.postSetHeight(
        babyId: 5,
        height: 0,
        date: "2025-11-02"
    )

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}
@Test func getWeights() async {

    let result = await BabyMoaService.shared.getGetWeights(
        babyId: 5
    )

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}
@Test func getHeights() async {

    let result = await BabyMoaService.shared.getGetHeights(
        babyId: 5
    )

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}
@Test func authRefresh() async {

    let result = await BabyMoaService.shared.postAuthRefresh(
        refreshToken: ""
    )

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}
@Test func addjourney() async {

    let result = await BabyMoaService.shared.postAddJourney(
        babyId: 9,
        journeyImage: "https://example.com/image.png",
        latitude: 37.5665,
        longitude: 126.9780,
        date: "2025-11-02",
        memo: "Hello World!"
    )

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}

@Test func setBabyMilestone() async {

    let result = await BabyMoaService.shared.postSetBabyMilestone(
        babyId: 9,
        milestoneIdx: 1,
        milestoneImage: "https://example.com/image.png",
        date: "2025-11-02",
        memo: "Hello World!"
    )

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}
@Test func getJourniesAtMonth() async {
    let result = await BabyMoaService.shared.getGetJourniesAtMonth(

        babyId: 14,
        year: 2025,
        month: 11
    )

    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}
@Test func getBabyMilestones() async {
    let result = await BabyMoaService.shared.getGetBabyMilestones(
        babyId: 14
    )
    
    switch result {
    case .success(let success):
        print(success)
    case .failure(let error):
        print(error)
    }
}
