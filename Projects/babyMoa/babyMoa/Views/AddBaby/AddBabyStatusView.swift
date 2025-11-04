//
//  AddBabyStatusView.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import SwiftUI

struct AddBabyStatusView: View {
    @StateObject var viewModel = AddBabyViewModel()
    
    let genderSegments: [Segment] = [
        Segment(tag: "MALE", title: "남아"),
        Segment(tag: "FEMALE", title: "여아"),
        Segment(tag: "NONE", title: "미정")
    ]
    
    //MARK: - 뷰 스타트
    @State private var isBorn: Bool = true
    @State private var isFormValid: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                CustomNavigationBar(title: "아기 정보 입력하기", leading: {
                    Button(action: { }) {
                        Image(systemName: "chevron.left")
                    }
                })
                
                BabyProfileImageView(profileImage: .constant(nil), selectedPhotoItem: .constant(nil))
                
                VStack(spacing: 20){
                    
                    if isBorn {
                        BabyInputField(label: "이름 (필수)", placeholder: "이름을 입력해주세요", text: $viewModel.babyName)
                        BabyInputField(label: "태명 (선택)", placeholder: "태명을 입력해주세요", text: $viewModel.babyNickname)
                        GenderSelectionView(selectedGender: $viewModel.selectedGender, segments: genderSegments)
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
                    
                })
                .buttonStyle(!isFormValid ? .noneButton : .defaultButton)
                
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
