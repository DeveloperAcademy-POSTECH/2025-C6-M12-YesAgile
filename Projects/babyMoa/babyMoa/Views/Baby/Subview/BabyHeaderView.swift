import SwiftUI

enum HeaderButtonType {
    case navigate
    case delete
    case settings
    case none // 버튼이 없는 경우 추가
}

struct BabyHeaderView: View {
    let babyName: String
    let buttonType: HeaderButtonType
    let onButtonTap: () -> Void
    
    var body: some View {
        ZStack{
            HStack(spacing: 20){
                Image("baby_milestone_illustration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                
                HStack(spacing: 5){
                    Text(babyName)
                        .font(.system(size: 16, weight: .bold))
                    
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color.brand50)
                        .font(.system(size: 14, weight: .bold))
                }
                
                Spacer()
            }
            
            HStack{
                Spacer()
                
                // buttonType이 .none이 아닐 때만 버튼을 렌더링
                if buttonType != .none {
                    Button(action: onButtonTap) {
                        switch buttonType {
                        case .navigate:
                            Image(systemName: "chevron.right")
                        case .delete:
                            Image(systemName: "trash")
                        case .settings:
                            Image(systemName: "gearshape")
                        case .none:
                            EmptyView() // .none일 때는 아무것도 렌더링하지 않음
                        }
                    }
                    .foregroundStyle(Color.brand50)
                    .font(.system(size: 22, weight: .bold))
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        BabyHeaderView(babyName: "김아기", buttonType: .settings, onButtonTap: {
            print("Settings button tapped")
        })
        BabyHeaderView(babyName: "이아기", buttonType: .navigate, onButtonTap: {
            print("Navigate button tapped")
        })
        BabyHeaderView(babyName: "박아기", buttonType: .delete, onButtonTap: {
            print("Delete button tapped")
        })
        BabyHeaderView(babyName: "최아기", buttonType: .none, onButtonTap: {
            print("This should not be called")
        })
    }
}
