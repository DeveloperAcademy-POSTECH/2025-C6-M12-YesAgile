import SwiftUI

struct BabyProfileCard: View {
    
    var coordinator: BabyMoaCoordinator
    let baby: Babies
    
    private var ageText: String {
        let calendar = Calendar.current
        guard let birthDate = DateFormatter.yyyyDashMMDashdd.date(from: baby.birthDate) else {
            return ""
        }
        let components = calendar.dateComponents([.month, .day], from: birthDate, to: Date())
        if let month = components.month, month > 0 {
            return "\(month)개월 \(components.day ?? 0)일"
        } else if let day = components.day, day >= 0 {
            return "\(day)일"
        }
        return ""
    }

    var body: some View {
        VStack(spacing: 8){
            HStack(spacing: 15){
                if let url = URL(string: baby.avatarImageName) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 70, height: 70)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Image("defaultAvata")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                } else {
                    Image("defaultAvata")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.brand40.opacity(0.2), lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                }
                
                VStack(alignment:.leading, spacing: 0){
                    HStack{
                        Text("\(baby.name)(\(baby.alias))")
                            .font(.system(size: 16, weight: .bold))
                        Text(baby.gender)
                            .font(.system(size: 14, weight: .medium))
                            .frame(height: 25)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .overlay {
                                Capsule()
                                    .stroke(Color.gray90, lineWidth: 2)
                            }
                        
                    }
                    .padding(.bottom, 11)
                    Text(ageText)
                        .font(.system(size: 14, weight: .medium))
                        .padding(.bottom, 8)
                    
                }
                Spacer()
                Button(action: {
                    // Note: `AddBabyModel`'s relationship is not available in `Babies` model.
                    // A default or placeholder value might be needed.
                    guard let birthDate = DateFormatter.yyyyDashMMDashdd.date(from: baby.birthDate) else {
                        return
                    }
                    let babyToEdit = AddBabyModel(
                        id: baby.babyId,
                        babyId: baby.babyId,
                        name: baby.name,
                        nickname: baby.alias,
                        gender: baby.gender,
                        birthDate: birthDate,
                        relationship: "", // Placeholder, as it's not in Babies model
                        profileImage: baby.avatarImageName,
                        isBorn: true
                    )
                    
                    coordinator.push(path: .addBabyStatus(baby: babyToEdit, isBorn: true))
                }, label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.gray40.opacity(0.3))
                        .font(.system(size: 17, weight: .semibold))
                    
                })
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray90, lineWidth: 1)
        }
    }
}


#Preview {
    let sampleImageUrl = "https://yesagile-s3-bucket.s3.amazonaws.com/avatars/2025/11/08/38d90084-0fcd-4f34-bc25-471dc2d2f704.jpg"
    
    return BabyProfileCard(coordinator: BabyMoaCoordinator(), baby: Babies(
        babyId: 1,
        alias: "튼튼이",
        name: "김아기",
        birthDate: "2025-11-09",
        gender: "M",
        avatarImageName: sampleImageUrl
    ))
}