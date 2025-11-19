//
//  MilestoneCardView.swift
//  babyMoa
//
//  Created by Baba on 11/11/25.
//

import SwiftUI

struct MilestoneCardView: View {
    let milestone: GrowthMilestone
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let cardType: MilestoneCardType
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            if let image = milestone.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.9)   // 수정해야 한다.
            } else {
                Image(milestone.illustrationName!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(milestone.completedDate == nil ? 0.7 : 1)
                    .padding(.horizontal, 10)
            }
            VStack {
                Spacer().frame(height: cardType == .small ? 10 : 20)
                Text(milestone.completedDate != nil ? DateFormatter.yyyyMMdd.string(from: milestone.completedDate!) : "사진을 넣어 주세요")
                    .font(.system(size: cardType.dateFontSize, weight: .bold))
                Spacer()
                Text(milestone.title)
                    .font(.system(size: cardType.titleFontSize, weight: .bold))
                Spacer().frame(height: cardType == .small ? 10 : 20)
            }
            .frame(width: cardWidth, height: cardHeight)
            .foregroundStyle(milestone.completedDate == nil ? .orange70 : milestone.image == nil ? .orange50 : .white)
        }
        //        .frame(width: cardWidth, height: cardHeight)
        .frame(width: cardWidth)
        .frame(height: cardHeight)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 10)
        .onTapGesture {
            onTap()
        }
    }
}

/// 마일스톤 각 카드 항목 상 보여지는 폰트의 크기를 조절하기 위한 타입 값입니다.
enum MilestoneCardType {
    case small
    case big
    
    var dateFontSize: CGFloat {
        switch self {
        case .small:
            return 8
        case .big:
            return 18
        }
    }
    
    var titleFontSize: CGFloat {
        switch self {
        case .small:
            return 10
        case .big:
            return 30
        }
    }
}

#Preview("Completed Milestone") {
    MilestoneCardView(
        milestone: GrowthMilestone(
            id: "milestone_0_0",
            title: "목가누기",
            ageRange: "3~4개월",
            isCompleted: true,
            completedDate: Date(),
            illustrationName: "Baby07"
        ),
        cardWidth: 150,
        cardHeight: 200,
        cardType: .small,
        onTap: {}
    )
}

#Preview("Incomplete Milestone") {
    MilestoneCardView(
        milestone: GrowthMilestone(
            id: "milestone_0_1",
            title: "혼자 앉기",
            ageRange: "7~8개월",
            isCompleted: false,
            completedDate: nil,
            illustrationName: "Baby19"
        ),
        cardWidth: 150,
        cardHeight: 200,
        cardType: .small,
        onTap: {}
    )
}
