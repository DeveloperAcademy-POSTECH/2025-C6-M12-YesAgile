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
    var annotations: [Journey]
    var userLocation: CLLocation?
}

/// MapCard의 사용자 액션
struct MapCardActions {
    var onMarkerTap: (Date) -> Void
    var onCompassTap: () -> Void
}

struct MapCard: View {
    let data: MapCardData
    let actions: MapCardActions
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: data.position) {
                ForEach(data.annotations) { journey in
                    Annotation("", coordinate: journey.coordinate) {
                        PhotoMarkerView(image: journey.journeyImage)
                            .onTapGesture {
                                actions.onMarkerTap(journey.date)
                            }
                    }
                }
                
                if let userLocation = data.userLocation {
                    Annotation("", coordinate: userLocation.coordinate) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 18, height: 18)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                            )
                            .shadow(radius: 2)
                    }
                }
            }
            .mapStyle(.standard)
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 16))
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
    }
}

// MARK: - Photo Marker View ( 컴포넌트 분리)

/// 사진 마커 뷰 - 지도 위 커스텀 마커
struct PhotoMarkerView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 36, height: 36)
            .clipShape(Circle())
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
    
    return VStack {
        MapCard(
            data: MapCardData(
                position: $position,
                annotations: mockAnnotations,
                userLocation: nil
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
