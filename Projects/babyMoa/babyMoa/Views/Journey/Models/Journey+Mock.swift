//
//  Journey+Mock.swift
//  BabyMoa
//
//  Created by pherd on 11/7/25.
//

import CoreLocation
import Foundation
import PhotosUI

// MARK: - Mock Data

#if DEBUG
    extension Journey {
        /// 목업 데이터 (UI 개발용)
        static var mockData: [Journey] {
            let today = Date()
            let calendar = Calendar.current

            return [
                // 오늘 (3장)
                Journey(
                    id: "mock-1",
                    image: createSampleImage(
                        systemName: "photo.fill",
                        color: .blue
                    ),
                    coordinate: CLLocationCoordinate2D(
                        latitude: 37.5665,
                        longitude: 126.9780
                    ),
                    date: today,
                    memo: "아이와 함께 마트에 갔어요"
                ),
                Journey(
                    id: "mock-2",
                    image: createSampleImage(
                        systemName: "camera.fill",
                        color: .green
                    ),
                    coordinate: CLLocationCoordinate2D(
                        latitude: 37.5666,
                        longitude: 126.9781
                    ),
                    date: today,
                    memo: "같은 날 두 번째 사진"
                ),
                Journey(
                    id: "mock-3",
                    image: createSampleImage(
                        systemName: "heart.fill",
                        color: .red
                    ),
                    coordinate: CLLocationCoordinate2D(
                        latitude: 37.5667,
                        longitude: 126.9782
                    ),
                    date: today,
                    memo: "같은 날 세 번째 사진"
                ),
                // 1일 전
                Journey(
                    id: "mock-4",
                    image: createSampleImage(
                        systemName: "star.fill",
                        color: .yellow
                    ),
                    coordinate: CLLocationCoordinate2D(
                        latitude: 37.5796,
                        longitude: 126.9770
                    ),
                    date: calendar.date(byAdding: .day, value: -1, to: today)!,
                    memo: "경복궁 방문"
                ),
                // 2일 전
                Journey(
                    id: "mock-5",
                    image: createSampleImage(
                        systemName: "moon.fill",
                        color: .purple
                    ),
                    coordinate: CLLocationCoordinate2D(
                        latitude: 37.5172,
                        longitude: 127.0473
                    ),
                    date: calendar.date(byAdding: .day, value: -2, to: today)!,
                    memo: "한강 공원 산책"
                ),
                // 5일 전
                Journey(
                    id: "mock-6",
                    image: createSampleImage(
                        systemName: "gift.fill",
                        color: .systemPink
                    ),
                    coordinate: CLLocationCoordinate2D(
                        latitude: 37.5114,
                        longitude: 127.0591
                    ),
                    date: calendar.date(byAdding: .day, value: -5, to: today)!,
                    memo: "롯데월드 방문"
                ),
                // 10일 전
                Journey(
                    id: "mock-7",
                    image: createSampleImage(
                        systemName: "sun.max.fill",
                        color: .orange
                    ),
                    coordinate: CLLocationCoordinate2D(
                        latitude: 37.5400,
                        longitude: 127.0697
                    ),
                    date: calendar.date(byAdding: .day, value: -10, to: today)!,
                    memo: "서울숲 나들이"
                ),
            ]
        }

        /// 테스트용 시스템 이미지 생성
        private static func createSampleImage(
            systemName: String,
            color: UIColor
        ) -> UIImage {
            let config = UIImage.SymbolConfiguration(
                pointSize: 100,
                weight: .regular
            )
            let image = UIImage(
                systemName: systemName,
                withConfiguration: config
            )?
            .withTintColor(color, renderingMode: .alwaysOriginal)

            // 배경에 아이콘 그리기
            let size = CGSize(width: 200, height: 200)
            let renderer = UIGraphicsImageRenderer(size: size)

            return renderer.image { context in
                // 배경
                UIColor.systemGray6.setFill()
                context.fill(CGRect(origin: .zero, size: size))

                // 아이콘
                if let image = image {
                    let rect = CGRect(x: 50, y: 50, width: 100, height: 100)
                    image.draw(in: rect)
                }
            }
        }
    }
#endif
