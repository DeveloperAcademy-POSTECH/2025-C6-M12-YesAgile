//
//  MapCard.swift
//  babyMoa
//
//  Created by pherd on 11/7/25.
//

import MapKit
import SwiftUI

/// // MARK: - Data & Actions
/// MapCard에 전달할 데이터 지도 카드 컴포넌트
struct MapCardData {
    var position: Binding<MapCameraPosition>
    var annotations: [JourneyAnnotation]
}

/// MapCard의 사용자 액션
struct MapCardActions {
    var onMarkerTap: (Date) -> Void
    var onCompassTap: () -> Void
}

struct MapCard: View {
    let data: MapCardData
    let actions: MapCardActions
    // 여기서 쓰는 value들 직접 뷰모델 받아서 쓰지말고, 프로퍼티로 선언해서 뷰에서 주입 및 호출수 있도록!
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: data.position) {
                ForEach(data.annotations) { annotation in
                    Annotation("", coordinate: annotation.coordinate) {
                        PhotoMarkerView(
                            image: annotation.image,
                            count: annotation.count  // 마커 안에 보여줄 사진 이미지와 같은 날짜 여정 개수를 표시,
                        )
                        .onTapGesture {
                            actions.onMarkerTap(annotation.date)
                        }
                    }
                }
            }
            .mapStyle(.standard)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)

            // 나침반 버튼 (우측 상단)
            Button {
                actions.onCompassTap()
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
}

// MARK: - Photo Marker View ( 컴포넌트 분리)

/// 사진 마커 뷰 - 지도 위 커스텀 마커
struct PhotoMarkerView: View {
    let image: UIImage
    let count: Int  //같은 날짜의 여정 개수

    var body: some View {
        VStack(spacing: 4) {  //VStack으로 변경 (개수 표시 추가)
            ZStack {
                // 배경 원
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)

                // 사진
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }

            // 2개 이상일 때만 개수 표시
            if count > 1 {
                Text("\(count)개")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
}


// MARK: - Preview

#Preview {
    @Previewable @State var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.5665,
                longitude: 126.9780
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )

    let mockAnnotations = Journey.mockData
        .filter { journey in
            journey.latitude != 0 && journey.longitude != 0
        }
        .map { journey in
            JourneyAnnotation(from: journey, count: 1)  // Preview용 count 추가
        }

    return VStack {
        MapCard(
            data: MapCardData(
                position: $position,
                annotations: mockAnnotations
            ),
            actions: MapCardActions(
                onMarkerTap: { _ in },
                onCompassTap: {}
            )
        )
        Spacer()
    }
    .padding(.horizontal, 20)
    .background(Color(.systemGroupedBackground))
}
