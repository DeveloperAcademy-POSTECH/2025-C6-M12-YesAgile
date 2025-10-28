//
//  GrowthAPIEndpoint.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  성장(키/몸무게/치아 제외) 마일스톤 전용 엔드포인트 정의
//  - 이 파일은 단순히 URL, HTTP 메서드, 헤더/바디 구성을 책임집니다.
//  - 실제 네트워크 전송은 GrowthAPIClient가 담당합니다.
//

import Foundation

enum GrowthHTTPMethod: String { case GET, POST, PUT }

enum GrowthAPIEndpoint {
    // 전체 성장 마일스톤(예: 64개) 조회 (키/몸무게/치아 제외)
    case getAllMilestones(babyId: String)

    // 마일스톤 메타데이터 업데이트(완료일, 메모, 완료여부, 이미지 URL 등)
    case updateMilestone(milestoneId: String)

    // 마일스톤 이미지 업로드(멀티파트)
    case uploadMilestoneImage(milestoneId: String)
}

extension GrowthAPIEndpoint {
    // NOTE: 실제 서버 베이스 URL로 교체하세요.
    // 예: https://api.example.com
    private var baseURL: String { return "https://api.your-server.com" }

    var method: GrowthHTTPMethod {
        switch self {
        case .getAllMilestones: return .GET
        case .updateMilestone: return .PUT
        case .uploadMilestoneImage: return .POST
        }
    }

    var path: String {
        switch self {
        case .getAllMilestones:
            return "/milestones"
        case .updateMilestone(let milestoneId):
            return "/milestones/\(milestoneId)"
        case .uploadMilestoneImage(let milestoneId):
            return "/milestones/\(milestoneId)/image"
        }
    }

    // 공통 헤더 기본값(Authorization은 Client에서 주입)
    var defaultHeaders: [String: String] {
        ["Content-Type": "application/json", "Accept": "application/json"]
    }

    // URLRequest 생성기 (body/headers는 호출부에서 조립)
    func makeURLRequest(queryItems: [URLQueryItem]? = nil) throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw GrowthNetworkError.invalidURL
        }
        components.queryItems = queryItems
        guard let url = components.url else { throw GrowthNetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        defaultHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}


