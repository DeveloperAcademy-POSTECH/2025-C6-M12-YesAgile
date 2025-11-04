//
//  TopNavigationView.swift
//  babyMoa
//
//  Created by Baba on 10/22/25.
//

import SwiftUI


// Padding은 상위 뷰의 영향을 받기 때문에 적용하지 않음. 버튼의 글자 색은 표준으로 정하고 사용하는 뷰에서 적용할 수 있게 만듬.
struct CustomNavigationBar<Leading, Trailing>: View where Leading: View, Trailing: View {
    let title: String
    let leading: Leading
    let trailing: Trailing

    // 기본 생성자
    init(title: String, @ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) {
        self.title = title
        self.leading = leading()
        self.trailing = trailing()
    }

    var body: some View {
        ZStack {
            // Title in the center
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .default))
                Spacer()
            }

            // Leading and Trailing buttons
            HStack {
                leading
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.brandMain)
                Spacer()
                trailing
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.brandMain)


            }
        }
        .frame(height: 44)
        .padding(.top, 66)
    }
}

// 경우의 수에 따라 화면 - 좌측만 있는 경우, 우측만 있는 경우 둘다 있는 경우, 가운데 타이틀만 있는 경우
extension CustomNavigationBar where Leading == EmptyView, Trailing == EmptyView {
    init(title: String) {
        self.init(title: title, leading: { EmptyView() }, trailing: { EmptyView() })
    }
}

extension CustomNavigationBar where Trailing == EmptyView {
    init(title: String, @ViewBuilder leading: () -> Leading) {
        self.init(title: title, leading: leading, trailing: { EmptyView() })
    }
}

extension CustomNavigationBar where Leading == EmptyView {
    init(title: String, @ViewBuilder trailing: () -> Trailing) {
        self.init(title: title, leading: { EmptyView() }, trailing: trailing)
    }
}


#Preview {
    VStack(spacing: 20) {
        // 1. Title, Leading, Trailing 모두 있는 경우
        CustomNavigationBar(title: "아기 추가", leading: {
            Button(action: { }) {
                Image(systemName: "chevron.left")
            }
        }, trailing: {
            Button(action: { }) {
                Text("완료")
            }
        })
        
        // 2. Trailing이 없는 경우
        CustomNavigationBar(title: "설정", leading: {
            Button(action: { }) {
                Image(systemName: "chevron.left")
            }
        })
        
        // 3. Leading이 없는 경우
        CustomNavigationBar(title: "알림", trailing: {
            Button(action: { }) {
                Image(systemName: "gear")
            }
        })
        
        // 4. Title만 있는 경우
        CustomNavigationBar(title: "마이페이지")
    }
}
