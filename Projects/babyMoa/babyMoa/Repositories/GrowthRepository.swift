//
//  GrowthRepository.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  성장 마일스톤 데이터 접근 레이어
//  - APIClient 호출
//  - 모델 변환(Date <-> String)
//  - 2개월 단위 그룹핑
//

import Foundation
import UIKit

struct UpdateMilestonePayload: Codable {
    let completedDate: String?
    let description: String?
    let isCompleted: Bool?
    let imageURL: String?
}

final class GrowthRepository {
    static let shared = GrowthRepository()
    private init() {}
    
    // MARK: - Load All Milestones (64개 가정)
    /// 서버에서 성장 마일스톤(키/몸무게/치아 제외)을 모두 가져온 뒤 2개월 단위로 그룹핑합니다.
    func loadAllMilestones(babyId: String) async throws -> [[GrowthMilestone]] {
        struct Response: Decodable { let data: [GrowthMilestone] }
        let query = [URLQueryItem(name: "babyId", value: babyId), URLQueryItem(name: "type", value: "growth-only")]
        let res: Response = try await GrowthAPIClient.shared.requestJSON(.getAllMilestones(babyId: babyId), queryItems: query, responseType: Response.self)
        return groupByTwoMonths(res.data)
    }
    
    // MARK: - Update Milestone Meta
    /// 날짜/메모/완료 여부/이미지 URL 업데이트
    func updateMilestone(milestoneId: String, date: Date?, memo: String?, imageURL: String?, isCompleted: Bool?) async throws {
        let body = UpdateMilestonePayload(
            completedDate: date.map { GrowthRepository.backendString(from: $0) },
            description: memo,
            isCompleted: isCompleted,
            imageURL: imageURL
        )
        let data = try JSONEncoder().encode(body)
        _ = try await GrowthAPIClient.shared.requestJSON(.updateMilestone(milestoneId: milestoneId), body: data, responseType: Empty.self)
    }
    
    // MARK: - Upload Image (Multipart)
    /// 이미지 1장을 업로드하고 서버가 돌려준 raw Data를 그대로 반환(상위에서 JSON 파싱)
    func uploadMilestoneImage(milestoneId: String, image: UIImage) async throws -> Data {
        return try await GrowthAPIClient.shared.uploadImage(.uploadMilestoneImage(milestoneId: milestoneId), image: image)
    }
    
    // MARK: - Helpers
    private func groupByTwoMonths(_ list: [GrowthMilestone]) -> [[GrowthMilestone]] {
        // 서버에서 이미 정렬되어 온다고 가정. 필요 시 정렬 추가.
        var buckets: [[GrowthMilestone]] = []
        buckets.reserveCapacity(32) // 2개월 단위 섹션 수
        var current: [GrowthMilestone] = []
        for (i, item) in list.enumerated() {
            current.append(item)
            if i % 2 == 1 { buckets.append(current); current.removeAll() }
        }
        if !current.isEmpty { buckets.append(current) }
        return buckets
    }
    
    static func backendString(from date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd.HH.mm.ss"
        f.timeZone = .current
        return f.string(from: date)
    }
}

private struct Empty: Decodable {}


