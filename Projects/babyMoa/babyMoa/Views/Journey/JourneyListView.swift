//
//  JourneyListView.swift
//  babyMoa
//
//  Created by pherd on 11/11/25.
//
import SwiftUI

struct JourneyListView: View {
    var body: some View {
        VStack(spacing: 0) {
            // 날짜 헤더 Date 주입예정
            Text("2025.11.10")
                .font(.system(size: 18, weight: .semibold))
                .padding(.vertical, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    // 샘플 카드 1
                    JourneyCard(
                        imageUrl: nil,
                        memo: "오늘 아기와 공원에서 즐거운 시간을 보냈어요! 날씨도 좋고 아기도 기분이 좋아 보였습니다."
                    )
                    
                    // 샘플 카드 2
                    JourneyCard(
                        imageUrl: nil,
                        memo: "첫 이유식 도전! 조금 먹었어요 😊"
                    )
                    
                    // 샘플 카드 3
                    JourneyCard(
                        imageUrl: nil,
                        memo: "낮잠 시간"
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
            
            Spacer()
            
            // 여정 추가 버튼
            Button(action: {
                // 버튼 동작 없음
                print("여정 추가 버튼 클릭")
            }) {
                Text("여정 추가")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 1.0, green: 0.3, blue: 0.2))
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
    }
}

// MARK: - Journey Card

struct JourneyCard: View {
    let imageUrl: String?
    let memo: String
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 12) {
                // 사진 영역 (placeholder)
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 450)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                    )
                
                // 메모 텍스트
                Text(memo)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
            .background(Color.background)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            
            // 삭제 버튼 (우측 상단)
            Button(action: {
                showDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 1.0, green: 0.3, blue: 0.2))
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(12)
        }
        .alert("아이와 함께한 소중한 추억", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                print("삭제 버튼 클릭")
            }
        } message: {
            Text("추억을 삭제 하시겠습니까?")
        }
    }
}

// MARK: - Preview

#Preview {
    JourneyListView()
}
