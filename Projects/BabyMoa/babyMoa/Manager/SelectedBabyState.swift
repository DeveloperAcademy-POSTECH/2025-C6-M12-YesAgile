//
//  SelectedBabyState.swift
//  babyMoa
//
//  Created by Baba on 11/8/25.
//

import Foundation
import Combine

/// 앱 전체에서 현재 선택된 아기의 상세 정보를 공유하기 위한 싱글톤 클래스입니다.
/// 이 객체를 통해 여러 뷰모델이 선택된 아기의 변경 사항을 감지하고 반응할 수 있습니다.
final class SelectedBabyState: ObservableObject {
    /// 앱의 유일한 공유 인스턴스
    static let shared = SelectedBabyState()
    
    /// 현재 선택된 아기의 상세 정보. 변경되면 이 객체를 구독하는 모든 뷰가 업데이트됩니다.
    @Published var baby: Babies?
    
    private init() {}
}
