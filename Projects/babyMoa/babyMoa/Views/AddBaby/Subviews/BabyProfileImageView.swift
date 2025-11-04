

//
//  BabyProfileImageView.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import SwiftUI
import PhotosUI

struct BabyProfileImageView: View {
    @Binding var profileImage: UIImage?
    @Binding var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            } else {
                Image("baby_milestone_illustration")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
        }
    }
}
#Preview {
    BabyProfileImageView(profileImage: .constant(nil), selectedPhotoItem: .constant(nil))
}
