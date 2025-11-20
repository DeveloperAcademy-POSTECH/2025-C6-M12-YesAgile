//
//  NewTooth.swift
//  babyMoa
//
//  Created by Pherd on 10/27/25.
//
//  새로 난 치아 세션 모델 (TeethView 내부에서만 사용)
//  ⚠️ UI 전용 임시 모델 - 백엔드에는 TeethRecord로 변환하여 전송

import Foundation

/// 새로 난 치아 기록 (세션 내 임시 저장용)
/// - TeethView에서 사용자가 추가한 치아를 "완료" 버튼 누르기 전까지 관리
/// - 백엔드 전송 시 `TeethRecord`로 변환 필요
struct NewTooth: Identifiable, Equatable {
    var id: String { position.rawValue }
    let position: ToothPosition
    var date: Date
    
    /// 한글 표시명 (상악/하악 → 위/아래)
    var displayName: String {
        position.displayName
            .replacingOccurrences(of: "상악", with: "위")
            .replacingOccurrences(of: "하악", with: "아래")
            .replacingOccurrences(of: "_", with: " ")
    }
    
    /// 백엔드 전송용 TeethRecord로 변환
    /// - Parameter babyId: 현재 선택된 아기의 ID
    /// - Returns: API 전송 가능한 TeethRecord
    func toTeethRecord(babyId: String) -> TeethRecord {
        TeethRecord(
            babyId: babyId,
            position: position,
            hasErupted: true,
            date: date
        )
    }
}

