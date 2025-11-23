//
//  JourneyMapView.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//  Refactored on 11/22/25 (Snapshot Only)
//

import MapKit
import SwiftUI

/// 지도 스냅샷 카드 (정적 이미지)
/// - 사용자 위치와 현재 월 journeys 마커 표시
/// - 터치 시 전체 화면 지도로 이동하는 버튼 역할
struct JourneyMapView: View {
    // MARK: - Properties
    let userLocation: CLLocationCoordinate2D?  // 사용자 GPS 위치
    let journeys: [Journey]  // 현재 월의 journeys
    let onTap: () -> Void
    
    @State private var snapshotImage: UIImage? = nil
    @State private var isLoading = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // 1. 배경 (회색 박스 - 이미지가 없을 때만 보임)
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: 354, height: 400)
            
            // 2. 스냅샷 이미지 (있으면 위에 덮어씀)
            if let image = snapshotImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 354, height: 400)
                    .clipped()
            }
            
            // 3. 로딩 인디케이터 제거됨 (요청사항)
            
            // 4. 버튼 (유도 UI)
            Button {
                onTap()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "map.fill")
                    Text("여정지도 크게 보기")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.black.opacity(0.8))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.9))
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(16)
        }
        .frame(width: 354, height: 400)  // 전체 프레임 고정 (디자인 사이즈)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .onTapGesture {
            onTap()
        }
        // 데이터 변경 시 스냅샷 다시 찍기
        .onChange(of: userLocation?.latitude) { _, _ in takeSnapshot() }
        .onChange(of: userLocation?.longitude) { _, _ in takeSnapshot() }
        .onChange(of: journeys.count) { _, _ in takeSnapshot() }
        .onAppear {
            if snapshotImage == nil {
                takeSnapshot()
            }
        }
    }
    
    // MARK: - Snapshot Logic
    private func takeSnapshot() {
        guard !isLoading else { return }
        print("🗺️ [JourneyMapView] takeSnapshot started. UserLoc: \(String(describing: userLocation)), Journeys: \(journeys.count)")
        isLoading = true
        
        // 지도 중심 및 줌 레벨 결정
        let centerCoordinate: CLLocationCoordinate2D
        let span: MKCoordinateSpan
        
        if let userLoc = userLocation {
            // 1. 사용자 위치가 있으면 사용자 중심 (상세 뷰)
            centerCoordinate = userLoc
            span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        } else if let firstJourney = journeys.first(where: { $0.hasValidLocation && (abs($0.latitude) > 0.0001 || abs($0.longitude) > 0.0001) }) {
            // 2. 여정이 있으면 첫 번째 여정 중심 (상세 뷰)
            centerCoordinate = firstJourney.coordinate
            span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        } else {
            // 3. 둘 다 없으면 대한민국 전체 (광역 뷰)
            centerCoordinate = CLLocationCoordinate2D(latitude: 36.5, longitude: 127.8)
            span = MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 4.0)
        }
        
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: centerCoordinate, span: span)
        options.size = CGSize(width: 354 * 2, height: 400 * 2)  // Retina 대응
        options.scale = UIScreen.main.scale
        
        // 스냅샷 영역 내의 journeys만 필터링
        let visibleJourneys = journeys.filter { journey in
            guard journey.hasValidLocation else { return false }
            // (0,0) 근사값 체크: 위도와 경도의 절대값이 0.0001보다 작으면 유효하지 않은 것으로 간주
            guard abs(journey.latitude) > 0.0001 || abs(journey.longitude) > 0.0001 else { return false }
            
            let coord = journey.coordinate
            
            // 간단한 범위 체크
            let latDiff = abs(coord.latitude - centerCoordinate.latitude)
            let lonDiff = abs(coord.longitude - centerCoordinate.longitude)
            return latDiff <= span.latitudeDelta / 2 && lonDiff <= span.longitudeDelta / 2
        }
        print("🗺️ [JourneyMapView] Visible journeys in snapshot: \(visibleJourneys.count)")
        
        // 이미지 미리 준비하기 (Task 사용)
        Task {
            // 1. 이미지 다운로드 (병렬 처리)
            var preparedImages: [Int: UIImage] = [:] // JourneyID : Image
            
            await withTaskGroup(of: (Int, UIImage?).self) { group in
                for journey in visibleJourneys {
                    // 이미 로컬 이미지가 있으면 바로 사용
                    if let localImage = journey.journeyImage {
                        preparedImages[journey.journeyId] = localImage
                        continue
                    }
                    
                    // 없으면 URL 다운로드 시도
                    if let urlString = journey.imageUrl {
                        group.addTask {
                            let image = await ImageManager.shared.downloadImage(from: urlString)
                            return (journey.journeyId, image)
                        }
                    }
                }
                
                // 결과 수집
                for await (id, image) in group {
                    if let image = image {
                        preparedImages[id] = image
                    }
                }
            }
            
            print("🗺️ [JourneyMapView] Prepared images count: \(preparedImages.count)")
            
            // 2. 스냅샷 생성 시작
            let snapshotter = MKMapSnapshotter(options: options)
            snapshotter.start { snapshot, error in
                if let error = error {
                    print("❌ [JourneyMapView] Snapshot failed: \(error.localizedDescription)")
                    Task { @MainActor in self.isLoading = false }
                    return
                }
                
                guard let snapshot = snapshot else {
                    Task { @MainActor in self.isLoading = false }
                    return
                }
                
                // 3. 마커 그리기
                let image = UIGraphicsImageRenderer(size: options.size).image { context in
                    // 지도 배경
                    snapshot.image.draw(at: .zero)
                    
                    // 사용자 위치 마커
                    if let userLoc = userLocation {
                        let point = snapshot.point(for: userLoc)
                        let markerSize: CGFloat = 32
                        let rect = CGRect(
                            x: point.x - markerSize/2,
                            y: point.y - markerSize/2,
                            width: markerSize,
                            height: markerSize
                        )
                        
                        context.cgContext.setFillColor(UIColor.white.cgColor)
                        context.cgContext.fillEllipse(in: rect)
                        
                        let innerRect = rect.insetBy(dx: 4, dy: 4)
                        context.cgContext.setFillColor(UIColor.systemBlue.cgColor)
                        context.cgContext.fillEllipse(in: innerRect)
                    }
                    
                    // Journey 마커들
                    for journey in visibleJourneys {
                        let point = snapshot.point(for: journey.coordinate)
                        let markerSize: CGFloat = 60
                        let rect = CGRect(
                            x: point.x - markerSize/2,
                            y: point.y - markerSize/2,
                            width: markerSize,
                            height: markerSize
                        )
                        
                        context.cgContext.saveGState()
                        context.cgContext.addEllipse(in: rect)
                        context.cgContext.clip()
                        
                        // 준비된 이미지 사용
                        let imageToDraw = journey.journeyImage ?? preparedImages[journey.journeyId] ?? UIImage(systemName: "photo.circle.fill")!
                        imageToDraw.draw(in: rect)
                        
                        context.cgContext.restoreGState()
                        
                        context.cgContext.setStrokeColor(UIColor.white.cgColor)
                        context.cgContext.setLineWidth(4)
                        context.cgContext.strokeEllipse(in: rect)
                    }
                }
                
                Task { @MainActor in
                    self.snapshotImage = image
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    JourneyMapView(
        userLocation: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        journeys: Journey.mockData,
        onTap: {}
    )
}
