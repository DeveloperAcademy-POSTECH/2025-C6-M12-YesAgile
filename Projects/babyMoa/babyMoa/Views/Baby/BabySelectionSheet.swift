////
////  BabySelectionSheet.swift
////  babyMoa
////
////  Created by AI on 10/30/25.
////
////  아기 선택 Sheet (GrowthBabyHeader용)
//
//import SwiftUI
//
//struct BabySelectionSheet: View {
//    @Environment(\.dismiss) var dismiss
//    let babies: [Baby]
//    let onSelect: (Baby) -> Void
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 0) {
//                // 상단 핸들
//                RoundedRectangle(cornerRadius: 2.5)
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(width: 36, height: 5)
//                    .padding(.top, 12)
//                    .padding(.bottom, 20)
//                
//                // 아기 목록
//                if babies.isEmpty {
//                    VStack(spacing: 16) {
//                        Text("등록된 아기가 없습니다")
//                            .font(.system(size: 16))
//                            .foregroundColor(.gray)
//                        
//                        Button(action: {
//                            dismiss()
//                        }) {
//                            Text("아기 추가하러 가기")
//                                .font(.system(size: 14, weight: .semibold))
//                                .foregroundColor(Color("Brand-50"))
//                        }
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                } else {
//                    List {
//                        ForEach(babies) { baby in
//                            Button(action: {
//                                onSelect(baby)
//                                dismiss()
//                            }) {
//                                HStack(spacing: 12) {
//                                    // 프로필 이미지
//                                    profileImageView(for: baby)
//                                    
//                                    // 아기 정보
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text(displayName(for: baby))
//                                            .font(.system(size: 16, weight: .semibold))
//                                            .foregroundColor(Color("Font"))
//                                        
//                                        Text(ageText(for: baby))
//                                            .font(.system(size: 14))
//                                            .foregroundColor(.gray)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    // 선택 표시
//                                    if isSelected(baby) {
//                                        Image(systemName: "checkmark.circle.fill")
//                                            .foregroundColor(Color("Brand-50"))
//                                            .font(.system(size: 20))
//                                    }
//                                }
//                                .padding(.vertical, 8)
//                            }
//                        }
//                    }
//                    .listStyle(.plain)
//                }
//            }
//            .navigationTitle("아기 선택")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("닫기") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//        .presentationDetents([.medium, .large])
//        .presentationDragIndicator(.hidden)
//    }
//    
//    // MARK: - Helper Views
//    
//    @ViewBuilder
//    private func profileImageView(for baby: Baby) -> some View {
//        if let profileImage = ImageHelper.loadImage(fileName: baby.profileImage) {
//            Image(uiImage: profileImage)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 50, height: 50)
//                .clipShape(Circle())
//        } else {
//            Circle()
//                .fill(Color.gray.opacity(0.3))
//                .frame(width: 50, height: 50)
//                .overlay(
//                    Image(systemName: "face.smiling")
//                        .font(.system(size: 24))
//                        .foregroundColor(.gray)
//                )
//        }
//    }
//    
//    // MARK: - Helper Functions
//    
//    private func displayName(for baby: Baby) -> String {
//        if let name = baby.name, !name.isEmpty {
//            return name
//        }
//        return baby.nickname
//    }
//    
//    private func ageText(for baby: Baby) -> String {
//        let isPregnant = baby.isPregnant ?? false
//        if isPregnant {
//            return calculateDDay(from: baby.birthDate)
//        } else {
//            return calculateAge(from: baby.birthDate)
//        }
//    }
//    
//    private func isSelected(_ baby: Baby) -> Bool {
//        guard let selectedId = UserDefaults.standard.string(forKey: "selectedBabyId") else {
//            return false
//        }
//        return selectedId == baby.id
//    }
//    
//    /// D-day 계산
//    private func calculateDDay(from date: Date) -> String {
//        let calendar = Calendar.current
//        let today = calendar.startOfDay(for: Date())
//        let expected = calendar.startOfDay(for: date)
//        
//        let components = calendar.dateComponents([.day], from: today, to: expected)
//        let daysLeft = components.day ?? 0
//        
//        if daysLeft > 0 {
//            return "D-\(daysLeft)"
//        } else if daysLeft == 0 {
//            return "D-Day!"
//        } else {
//            return calculateAge(from: date)
//        }
//    }
//    
//    /// 나이 계산
//    private func calculateAge(from date: Date) -> String {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.month, .day], from: date, to: Date())
//        
//        let months = components.month ?? 0
//        let days = components.day ?? 0
//        
//        return "\(months)개월 \(days)일"
//    }
//}
//
//#Preview {
//    BabySelectionSheet(
//        babies: [
//            Baby(
//                id: "1",
//                gender: .male,
//                name: "응애",
//                nickname: "응애자일",
//                birthDate: Date(),
//                relationship: "아빠"
//            ),
//            Baby(
//                id: "2",
//                gender: .female,
//                nickname: "둘째",
//                birthDate: Calendar.current.date(byAdding: .month, value: 3, to: Date())!,
//                relationship: "아빠",
//                isPregnant: true
//            )
//        ],
//        onSelect: { _ in }
//    )
//}
//
