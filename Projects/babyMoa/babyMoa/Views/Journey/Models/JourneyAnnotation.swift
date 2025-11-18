//
//  JourneyAnnotation.swift
//  babyMoa
//
//  Created by pherd on 11/19/25.
//

import Foundation
import MapKit
import UIKit

/// 지도에 표시할 여정 마커 모델
/// - Journey 도메인 모델을 MapKit Annotation으로 변환 / 지도 위 여정 위치를 나타내는 데이터 / 마커를 그리기 위한 필요한 정보를 담은 모델
/// - 같은 GPS 좌표를 가진 여정을 날짜별로 구분하기 위해 날짜 기반 ID 사용
struct JourneyAnnotation: Identifiable {
    // 날짜 기반 고유 ID로 변경
    var id: String {
        "\(dateString)-\(coordinate.latitude)-\(coordinate.longitude)"
    }

    let journeyId: Int  // 원본 ID는 별도 보관 (서버 연동용)
    let coordinate: CLLocationCoordinate2D
    let image: UIImage  // 지도 마커에 표시할 사진
    let date: Date  //  마커 클릭 시 날짜 필터링용
    let count: Int  //  같은 날짜의 여정 개수 (마커 하단 "2개" 텍스트용)

    //  날짜를 문자열로 변환 (ID 생성용)
    private var dateString: String {
        DateFormatter.yyyyDashMMDashdd.string(from: date)
    }

    /// Journey 도메인 모델로부터 Annotation 생성 여정 데이터 및 개수

    init(from journey: Journey, count: Int) {
        self.journeyId = journey.journeyId
        self.coordinate = journey.coordinate
        self.image = journey.journeyImage
        self.date = journey.date
        self.count = count
    }
}
// 날짜 기반 고유 ID로 변경 이유
//      같은 GPS 좌표를 가진 사진을 다른 날짜에 업로드하면
//      journeyId만으로는 MapKit이 마커를 하나로 겹쳐서 표시함
//      날짜를 ID에 포함시키면 MapKit이 별개의 마커로 인식하여
//      자동으로 5~10m 정도 떨어뜨려 표시 (줌인 시 더 명확히 구분)
