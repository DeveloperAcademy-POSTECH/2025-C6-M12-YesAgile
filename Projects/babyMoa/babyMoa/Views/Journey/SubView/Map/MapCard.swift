//
//  MapCard.swift
//  babyMoa
//
//  Created by pherd on 11/7/25.
//  Refactored on 11/21/25 (Snapshot Only)
//

import MapKit
import SwiftUI

/// 지도 스냅샷 카드 (정적 이미지)
/// - 터치 시 전체 화면 지도로 이동하는 버튼 역할
struct MapCard: View {
    // MARK: - Properties
    let coordinate: CLLocationCoordinate2D
    let onTap: () -> Void
    
    @State private var snapshotImage: UIImage? = nil
    @State private var isLoading = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // 1. 배경 (스냅샷 이미지 or 로딩)
            if let image = snapshotImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            } else {
                // 로딩 상태 (회색 박스)
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 250)
                    .overlay(ProgressView())
            }
            
            // 2. 버튼 (유도 UI)
            Button {
                onTap()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "map.fill")
                    Text("지도 크게 보기")
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
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .onTapGesture {
            onTap()
        }
        // 좌표가 바뀌면 스냅샷 다시 찍기
        .onChange(of: coordinate.latitude) { _ in takeSnapshot() }
        .onChange(of: coordinate.longitude) { _ in takeSnapshot() }
        .onAppear {
            if snapshotImage == nil {
                takeSnapshot()
            }
        }
    }
    
    // MARK: - Snapshot Logic
    private func takeSnapshot() {
        guard !isLoading else { return }
        isLoading = true
        
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        options.size = CGSize(width: 400, height: 250)
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, _ in
            guard let snapshot = snapshot else { return }
            
            // 마커(파란 점) 그리기
            let image = UIGraphicsImageRenderer(size: options.size).image { context in
                snapshot.image.draw(at: .zero)
                
                let point = snapshot.point(for: coordinate)
                let markerSize: CGFloat = 12
                let rect = CGRect(
                    x: point.x - markerSize/2,
                    y: point.y - markerSize/2,
                    width: markerSize,
                    height: markerSize
                )
                
                context.cgContext.setFillColor(UIColor.systemBlue.cgColor)
                context.cgContext.setStrokeColor(UIColor.white.cgColor)
                context.cgContext.setLineWidth(2)
                context.cgContext.addEllipse(in: rect)
                context.cgContext.drawPath(using: .fillStroke)
            }
            
            DispatchQueue.main.async {
                self.snapshotImage = image
                self.isLoading = false
            }
        }
    }
}
