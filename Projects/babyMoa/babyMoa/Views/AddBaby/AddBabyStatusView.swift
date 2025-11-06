//
//  AddBabyStatusView.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import SwiftUI
import PhotosUI // For PhotosPicker

struct AddBabyStatusView: View {
    
    @StateObject var viewModel: AddBabyViewModel
    
    init(coordinator: BabyMoaCoordinator, baby: AddBabyModel? = nil, isBorn: Bool? = nil) {
        self._viewModel = StateObject(wrappedValue: AddBabyViewModel(coordinator: coordinator, baby: baby, isBorn: isBorn))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                CustomNavigationBar(title: "아기 정보 입력하기", leading: {
                    Button(action: { 
                        viewModel.coordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                })
                
                BabyProfileImageView()
                
                VStack(spacing: 20){
                    
                    BabyInputField(label: "이름 (선택)", placeholder: "이름을 입력해주세요", text: $viewModel.babyName)
                    BabyInputField(label: "태명 (필수)", placeholder: "태명을 입력해주세요", text: $viewModel.babyNickname)
                    
                    if viewModel.isBorn {
                        GenderSelectionView(selectedGender: $viewModel.selectedGender, segments: viewModel.availableGenderSegments, isBorn: true)

                    } else {
                        GenderSelectionView(selectedGender: $viewModel.selectedGender, segments: viewModel.availableGenderSegments, isBorn: false)

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
                
                HStack {
                    if viewModel.editingBaby != nil {
                        Button("삭제", action: {
                            viewModel.delete()
                        })
                        .buttonStyle(.secondButton) // Or a new destructive style
                    }
                    
                    Button("저장", action: {
                        viewModel.save()
                    })
                    .buttonStyle(!viewModel.isFormValid ? .noneButton : .defaultButton)
                }
                
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

#Preview("Create Mode - isBorn") {
    // 1. 생성 모드 Preview
    AddBabyStatusView(coordinator: BabyMoaCoordinator(), baby: nil, isBorn: true)
}

#Preview("Create Mode - Not Born") {
    // 1. 생성 모드 Preview
    AddBabyStatusView(coordinator: BabyMoaCoordinator(), baby: nil, isBorn: false)
}

#Preview("Edit Mode") {
    // 2. 수정 모드 Preview
    AddBabyStatusView(coordinator: BabyMoaCoordinator(), baby: AddBabyModel.mockAddBabyModel.first!)
}
