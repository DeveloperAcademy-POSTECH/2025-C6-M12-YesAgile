//
//  JourneyListContextWrapper.swift
//  babyMoa
//
//  Created by pherd on 11/21/25.
//

import Foundation

/// fullScreenCover 시트 오픈을 위한 포장지(Wrapper)
/// - 시트를 "유지"하는 역할. 내부 데이터가 갱신되어도 이 객체(id)는 변하지 않아야 함.
/// - FullMapView에서도 공유하기 위해 전역으로 분리
struct JourneyListContextWrapper: Identifiable {
    let id = UUID()
    let date: Date
    let journies: [Journey]
}
