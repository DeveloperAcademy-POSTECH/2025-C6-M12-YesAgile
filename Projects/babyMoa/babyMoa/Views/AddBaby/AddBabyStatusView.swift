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
    
    @StateObject private var imageLoaderViewModel = ImageLoaderViewModel()
    
    init(coordinator: BabyMoaCoordinator, baby: AddBabyModel? = nil, isBorn: Bool? = nil) {
        self._viewModel = StateObject(wrappedValue: AddBabyViewModel(coordinator: coordinator, baby: baby, isBorn: isBorn))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                CustomNavigationBar(
                    title: viewModel.navigationTitle,
                    leading: {
                        Button(action: { 
                            viewModel.coordinator.pop()
                        }) {
                            Image(systemName: "chevron.left")
                        }
                    },
                    trailing: {
                        if viewModel.editingBaby != nil {
                            Button(action: {
                                viewModel.delete()
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                )
                
                ZStack {
                    // 1. 버튼을 제거하고 이미지를 표시하는 로직만 남깁니다.
                    if let displayedImage = viewModel.displayedProfileImage {
                        displayedImage
                            .profileImageStyle()
                    } else {
                        // 2. 기본 이미지
                        Image("defaultAvata")
                            .profileImageStyle()
                    }
                }
                .onTapGesture {
                    // 3. 탭하면 showLibrary를 true로 설정합니다.
                    //    (showImageOptions가 아님)
                    viewModel.showLibrary = true
                }
//                Image("baby_milestone_illustration")
//                    .profileImageStyle()
//
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
                
                
                
                Button("저장", action: {
                    viewModel.save()
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
        .photosPicker(isPresented: $viewModel.showLibrary, selection: $imageLoaderViewModel.imageSelection, matching: .images, photoLibrary: .shared())
        .onChange(of: imageLoaderViewModel.imageToUpload) { _, newValue in
            if let newValue = newValue {
                viewModel.displayedProfileImage = Image(uiImage: newValue)
                viewModel.profileImage = newValue
                
            }
        }
        .alert("아기 정보를 삭제할까요?", isPresented: $viewModel.showDeleteConfirmation) {
            Button("삭제", role: .destructive) {
                viewModel.executeDelete()
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("나에게만 아기 정보가 삭제돼요.")
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


