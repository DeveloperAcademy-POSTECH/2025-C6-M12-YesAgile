//
//  AddBabyStatusView.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import SwiftUI
import PhotosUI // For PhotosPicker

struct AddBabyStatusView: View {
    @StateObject var viewModel = AddBabyViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                CustomNavigationBar(title: "아기 정보 입력하기", leading: {
                    Button(action: { }) {
                        Image(systemName: "chevron.left")
                    }
                })
                
//                BabyProfileImageView(profileImage: $viewModel.profileImage, selectedPhotoItem: $viewModel.selectedPhotoItem)
                
                VStack(spacing: 20){
                    
                    if viewModel.isBorn {
                        BabyInputField(label: "이름 (필수)", placeholder: "이름을 입력해주세요", text: $viewModel.babyName)
                        BabyInputField(label: "태명 (선택)", placeholder: "태명을 입력해주세요", text: $viewModel.babyNickname)
                        GenderSelectionView(selectedGender: $viewModel.selectedGender, segments: viewModel.genderSegments)
                    } else {
                        BabyInputField(label: "이름 (선택)", placeholder: "이름을 입력해주세요", text: $viewModel.babyName)
                        BabyInputField(label: "태명 (필수)", placeholder: "태명을 입력해주세요", text: $viewModel.babyNickname)
                    }
                }
                
                BirthDateSelectionView(
                    label: viewModel.birthDateLabel,
                    showDatePicker: $viewModel.showDatePicker
                )
                
                RelationshipSelectionView(
                    relationship: $viewModel.relationship,
                    showRelationshipPicker: $viewModel.showRelationshipPicker
                )
                
                
                Button("저장", action: {
                    // TODO: 저장 로직 구현
                })
                .buttonStyle(!viewModel.isFormValid ? .noneButton : .defaultButton)
                
                Spacer()
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .backgroundPadding(.horizontal)
            
            if viewModel.showDatePicker {
                DatePickerModal(birthDate: $viewModel.birthDate, showDatePicker: $viewModel.showDatePicker)
            }
            
            if viewModel.showRelationshipPicker {
                RelationshipPickerModal(relationship: $viewModel.relationship, showRelationshipPicker: $viewModel.showRelationshipPicker)
            }
        }
    }
}

#Preview {
    AddBabyStatusView()
}
