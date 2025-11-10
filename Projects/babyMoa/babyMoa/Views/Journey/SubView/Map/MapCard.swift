//
//  MapCard.swift
//  babyMoa
//
//  Created by pherd on 11/7/25.
//

import SwiftUI
import MapKit

/// 지도 카드 컴포넌트
struct MapCard: View {
    // Journey 데이터 (나중에 JourneyViewModel에서 받을 예정)
    let journies: [Journey] = []
    
    //  MapCameraPosition 공부 17+
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),  // 서울
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            //  MapContentBuilder
            Map(position: $position) {
                //  ForEach로 Annotation 추가
                ForEach(annotations) { annotation in
                    Annotation("", coordinate: annotation.coordinate) {
                        // 커스텀 마커 (컴포넌트 분리)
                        PhotoMarkerView(image: annotation.image)
                    }
                }
            }
            .mapStyle(.standard)  // 지도 스타일
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            
            // 나침반 버튼 (우측 상단)
            Button {
                withAnimation {
                    // iOS 17+ 방식으로 위치 이동
                    position = .region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        )
                    )
                }
                print("🧭 지도 중심 이동: 서울")
            } label: {
                Image(systemName: "location.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding(12)
        }
        .frame(height: 400)
    }
    
    // MARK: - Computed Properties
    
    /// 날짜별로 그룹화된 마커
    private var annotations: [JourneyAnnotation] {
        var uniqueAnnotations: [JourneyAnnotation] = []
        
        for journey in journies {
            // 같은 날짜가 이미 있는지 확인
            let exists = uniqueAnnotations.contains { annotation in
                Calendar.current.isDate(annotation.date, inSameDayAs: journey.date)
            }
            
            // 없으면 추가 (그 날의 대표 마커)
            if !exists {
                uniqueAnnotations.append(JourneyAnnotation(from: journey))
            }
        }
        
        return uniqueAnnotations
    }
}

// MARK: - Photo Marker View ( 컴포넌트 분리)

/// 사진 마커 뷰 - 지도 위 커스텀 마커
struct PhotoMarkerView: View {
    let image: UIImage?
    
    var body: some View {
        ZStack {
            // 배경 원
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
            
            // 사진 또는 기본 아이콘
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
        }
    }
}

// MARK: - Journey Annotation 뷰에 표시하기 위한 가벼운 모델

struct JourneyAnnotation: Identifiable {
    let id: Int
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?
    let date: Date
    
    init(from journey: Journey) {
        // ✅ Journey에 id가 생기므로 넣어줬음.
        self.id = journey.journeyId
        self.coordinate = journey.coordinate
        self.image = journey.journeyImage  // ✅ journeyImage로 수정
        self.date = journey.date
    }
}

// MARK: - Preview

#Preview {
    VStack {
        MapCard()
        Spacer()
    }
    .padding(.horizontal, 20)
    .background(Color(.systemGroupedBackground))
}

