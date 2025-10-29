//
//  GrowthMilestoneCard.swift
//  babyMoa
//
//  Created by Pherd on 10/26/25.
//
//  성장 마일스톤 카드 컴포넌트
//

import SwiftUI

struct GrowthMilestoneCard: View {
    @Binding var selectedMonth: Int
    let milestones: [GrowthMilestone]
    /// 로컬 이미지(방금 선택한 이미지)를 제공하는 클로저 (옵션)
    let localImageProvider: ((String) -> UIImage?)?
    let onMonthTap: () -> Void
    let onMilestoneTap: ((GrowthMilestone) -> Void)?

    private let monthRanges = [
        "0~2개월", "3~4개월", "5~6개월", "7~8개월", "9~10개월", "11~12개월", "13~14개월",
        "15~16개월", "17~18개월", "19~20개월", "21~22개월", "23~24개월",
    ]

    init(
        selectedMonth: Binding<Int>,
        milestones: [GrowthMilestone],
        localImageProvider: ((String) -> UIImage?)? = nil,
        onMonthTap: @escaping () -> Void,
        onMilestoneTap: ((GrowthMilestone) -> Void)? = nil
    ) {
        self._selectedMonth = selectedMonth
        self.milestones = milestones
        self.localImageProvider = localImageProvider
        self.onMonthTap = onMonthTap
        self.onMilestoneTap = onMilestoneTap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 헤더: 성장 마일스톤
            Text("성장 마일스톤")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color("Font"))
                .padding(.horizontal, 20)

            // 개월수 선택 (좌우 화살표 + 텍스트)
            HStack {
                // 왼쪽 화살표
                Button(action: {
                    if selectedMonth > 0 {
                        selectedMonth -= 1
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(
                            selectedMonth > 0
                                ? Color("Brand-50")
                                : Color.gray.opacity(0.3)
                        )
                }
                .disabled(selectedMonth == 0)

                Spacer()

                // 개월수 텍스트 (탭 가능)
                Button(action: onMonthTap) {
                    Text(monthRanges[safe: selectedMonth] ?? "0~2개월")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color("Brand-50"))
                        .padding(.horizontal, 28)
                        .padding(.vertical, 10)
                        .background(Color("Brand-50").opacity(0.1))
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                        )
                }

                Spacer()

                // 오른쪽 화살표
                Button(action: {
                    if selectedMonth < monthRanges.count - 1 {
                        selectedMonth += 1
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(
                            selectedMonth < monthRanges.count - 1
                                ? Color("Brand-50")
                                : Color.gray.opacity(0.3)
                        )
                }
                .disabled(selectedMonth >= monthRanges.count - 1)
            }
            .padding(.horizontal, 20)

            // 마일스톤 좌우 스크롤
            if milestones.isEmpty {
                EmptyMilestoneView()
                    .padding(.horizontal, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(milestones) { milestone in
                            MilestoneCardItem(
                                milestone: milestone,
                                localImageProvider: localImageProvider,
                                onTap: {
                                    onMilestoneTap?(milestone)
                                }
                            )
                            .frame(width: 160)  // 카드 고정 너비
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

// MARK: - 빈 마일스톤 뷰

struct EmptyMilestoneView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "star.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange.opacity(0.3))

            Text("이 개월수에는 마일스톤이 없습니다")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}

// MARK: - 마일스톤 카드 아이템

struct MilestoneCardItem: View {
    let milestone: GrowthMilestone
    let onTap: (() -> Void)?
    let localImageProvider: ((String) -> UIImage?)?

    init(
        milestone: GrowthMilestone,
        localImageProvider: ((String) -> UIImage?)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.milestone = milestone
        self.localImageProvider = localImageProvider
        self.onTap = onTap
    }

    // 이미지가 있는지 확인
    private var hasImage: Bool {
        if localImageProvider?(milestone.id) != nil {
            return true
        }
        if let imageURL = milestone.imageURL, !imageURL.isEmpty {
            return true
        }
        return false
    }

    var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(spacing: 8) {
                // 이미지/일러스트 영역 (정사각형)
                ZStack(alignment: .topLeading) {
                    if let local = localImageProvider?(milestone.id) {
                        // ✅ 로컬에서 방금 선택한 이미지 우선 표시 (중앙 정렬)
                        Image(uiImage: local)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 160)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 12,
                                    style: .continuous
                                )
                            )
                    } else if let imageURL = milestone.imageURL,
                        !imageURL.isEmpty, milestone.isCompleted
                    {
                        // 서버 이미지 표시 (중앙 정렬)
                        AsyncImage(url: URL(string: imageURL)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 160, height: 160)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 12,
                                            style: .continuous
                                        )
                                    )
                            case .failure, .empty:
                                placeholderIllustration
                            @unknown default:
                                placeholderIllustration
                            }
                        }
                    } else {
                        // 일러스트 표시 (미완료)
                        placeholderIllustration
                    }

                    // 날짜 표시 (이미지가 있고 날짜가 있는 경우만 상단 중앙에 표시)
                    if let date = milestone.completedDate,
                        hasImage
                    {
                        VStack {
                            Text(formattedCardDate(date))
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
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
                .aspectRatio(1, contentMode: .fit)

                // 타이틀
                Text(milestone.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("Brand-50"))
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    @ViewBuilder
    private var placeholderIllustration: some View {
        ZStack {
            // 배경색 (미완료는 연한 오렌지)
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color("Brand-50").opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(
                            Color("Brand-50").opacity(0.2),
                            style: StrokeStyle(lineWidth: 1.5, dash: [5, 3])
                        )
                )

            VStack(spacing: 12) {
                // 일러스트 아이콘 (나중에 실제 일러스트로 교체)
                Image(systemName: "figure.walk")
                    .font(.system(size: 50))
                    .foregroundColor(Color("Brand-50").opacity(0.6))

                // 미완료 텍스트
                Text("나는 할 수 없어")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("Brand-50"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
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

// 안전한 배열 접근을 위한 extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    GrowthMilestoneCard(
        selectedMonth: .constant(0),
        milestones: [
            GrowthMilestone(
                title: "화내기",
                ageRange: "0~2개월",
                isCompleted: true,
                completedDate: Date()
            ),
            GrowthMilestone(title: "기기", ageRange: "0~2개월", isCompleted: false),
        ],
        onMonthTap: {}
    )
}
