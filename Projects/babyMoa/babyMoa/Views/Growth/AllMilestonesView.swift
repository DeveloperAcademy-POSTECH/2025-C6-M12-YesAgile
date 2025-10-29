//
//  AllMilestonesView.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  전체 마일스톤 보기 뷰
//

import SwiftUI

struct AllMilestonesView: View {
    let allMilestones: [[GrowthMilestone]]
    /// 로컬에서 방금 선택한 이미지 제공(옵션)
    let localImageProvider: ((String) -> UIImage?)?

    init(
        allMilestones: [[GrowthMilestone]],
        localImageProvider: ((String) -> UIImage?)? = nil
    ) {
        self.allMilestones = allMilestones
        self.localImageProvider = localImageProvider
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(allMilestones.indices, id: \.self) { monthIndex in
                    VStack(alignment: .leading, spacing: 12) {
                        // 월령 헤더 (0-2, 3-4, 5-6...)
                        Text(monthRangeText(for: monthIndex))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)

                        // 가로 스크롤 카드 리스트 (원래 순서대로 표시)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(allMilestones[monthIndex]) { milestone in
                                    MilestoneThumbnail(
                                        milestone: milestone,
                                        localImageProvider: localImageProvider
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .padding(.vertical, 16)
        }
        .background(Color("Background"))
        .navigationTitle("전체 성장 마일스톤")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    private func monthRangeText(for index: Int) -> String {
        if index == 0 {
            return "0개월 - 2개월"
        } else {
            let start = index * 2 + 1
            let end = start + 1
            return "\(start)개월 - \(end)개월"
        }
    }

}

// MARK: - Thumbnail Card

private struct MilestoneThumbnail: View {
    let milestone: GrowthMilestone
    let localImageProvider: ((String) -> UIImage?)?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                // 이미지 또는 일러스트 (중앙 정렬)
                content
                    .frame(width: 120, height: 140)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                    )

                // 작성일 (이미지가 있고 날짜가 있는 경우만 표시)
                if let date = milestone.completedDate,
                    hasImage
                {
                    VStack {
                        Text(formattedCardDate(date))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.6))
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 6,
                                    style: .continuous
                                )
                            )
                            .padding(.top, 8)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            // 마일스톤명 (길면 …)
            Text(milestone.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 120, alignment: .leading)
        }
    }

    // 이미지가 있는지 확인
    private var hasImage: Bool {
        if localImageProvider?(milestone.id) != nil {
            return true
        }
        if let urlString = milestone.imageURL, !urlString.isEmpty {
            return true
        }
        return false
    }

    @ViewBuilder
    private var content: some View {
        if let local = localImageProvider?(milestone.id) {
            Image(uiImage: local)
                .resizable()
                .scaledToFill()
        } else if let urlString = milestone.imageURL, !urlString.isEmpty,
            milestone.isCompleted, let url = URL(string: urlString)
        {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill()
                default: placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        ZStack {
            // 일러스트가 있으면 일러스트 표시
            if let illustrationName = milestone.illustrationName {
                Image(illustrationName)
                    .resizable()
                    .scaledToFill()
            } else {
                // 없으면 기존 placeholder
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.orange.opacity(0.1))
                Text("곧 만나요!")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.orange)
            }
        }
    }

    // MARK: - Helper
    /// 카드에 표시할 날짜 포맷 (예: "10월 22일")
    private func formattedCardDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }
}

#Preview {
    AllMilestonesView(allMilestones: [
        [
            GrowthMilestone(
                title: "화내기",
                ageRange: "0~2개월",
                isCompleted: true,
                completedDate: Date()
            ),
            GrowthMilestone(title: "기기", ageRange: "0~2개월", isCompleted: false),
        ],
        [
            GrowthMilestone(
                title: "뒤집기",
                ageRange: "3~5개월",
                isCompleted: false
            ),
            GrowthMilestone(
                title: "목가누기",
                ageRange: "3~5개월",
                isCompleted: false
            ),
        ],
    ])
}
