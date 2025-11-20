import SwiftUI

enum HeaderButtonType {
    case navigate
    case delete
    case settings
    case none // 버튼이 없는 경우 추가
}

struct MainTopNavigtaionView: View {
    let babyName: String
    let babyImage: String? // 이미지 URL 문자열을 받도록 수정
    let buttonType: HeaderButtonType
    let onButtonTap: () -> Void
    
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                
                HStack(spacing: 20){
                    profileImageView
                    
                    Button(action: onButtonTap) {
                        HStack(spacing: 5){
                            Text(babyName)
                                .font(.system(size: 16, weight: .bold))
                            
                            Image(systemName: "chevron.down")
                                .foregroundStyle(Color.brand50)
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .foregroundStyle(.black)
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
            .backgroundPadding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color.background)
    }
    
    @ViewBuilder
    private var profileImageView: some View {
        if let imageUrlString = babyImage, let url = URL(string: imageUrlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .background(Color.orange.opacity(0.2))
                case .failure:
                    defaultAvatarImage
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        } else {
            defaultAvatarImage
        }
    }
    
    private var defaultAvatarImage: some View {
        Circle()
            .fill(Color.orange.opacity(0.2))
            .frame(width: 50, height: 50)
            .overlay(
                Image("defaultAvata")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.primary)
            )
            .overlay(
                Circle()
                    .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    // 샘플 이미지 URL (실제 동작하는 URL로 교체하여 테스트 가능)
    let sampleImageUrl = "https://yesagile-s3-bucket.s3.amazonaws.com/avatars/2025/11/08/38d90084-0fcd-4f34-bc25-471dc2d2f704.jpg"
    
    VStack(spacing: 20) {
        // 이미지가 있는 경우
        MainTopNavigtaionView(babyName: "김아기", babyImage: sampleImageUrl, buttonType: .settings, onButtonTap: {
            print("Settings button tapped")
        })
        // 이미지가 없는 경우 (기본 이미지 표시)
        MainTopNavigtaionView(babyName: "이아기", babyImage: nil, buttonType: .navigate, onButtonTap: {
            print("Navigate button tapped")
        })
        MainTopNavigtaionView(babyName: "박아기", babyImage: "defaultAvata", buttonType: .delete, onButtonTap: {
            print("Delete button tapped")
        })
        MainTopNavigtaionView(babyName: "최아기", babyImage: "defaultAvata", buttonType: .none, onButtonTap: {
            print("This should not be called")
        })
    }
}
