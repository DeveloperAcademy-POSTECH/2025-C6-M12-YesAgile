//
//  ProfileImageView.swift
//  babyMoa
//
//  Created by pherd on 10/29/25.
//

import SwiftUI

struct ProfileImageView: View {
    let profileImage: UIImage?
    let profileImageName: String?
    let size: CGFloat
    
    var body: some View {
        Group {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else if let imageName = profileImageName,
                      let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: "face.smiling")
                            .font(.system(size: size * 0.5))
                            .foregroundColor(.gray)
                    )
            }
        }
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 3)
        )
    }
}


