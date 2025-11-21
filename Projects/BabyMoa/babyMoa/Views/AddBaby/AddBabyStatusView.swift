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
    
    enum FocusField: Hashable {
        case babyName
        case babyNickname
    }
    
    @FocusState private var focusedField: FocusField?
    
    init(
        coordinator: BabyMoaCoordinator,
        baby: AddBabyModel? = nil,
        isBorn: Bool? = nil
    ) {
        self._viewModel = StateObject(
            wrappedValue: AddBabyViewModel(
                coordinator: coordinator,
                baby: baby,
                isBorn: isBorn
            )
        )
    }
    
    var body: some View {
        ZStack {
            Color.background
            VStack(spacing: 0) {
                // MARK: - Custom Navigation Bar
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
                
                // MARK: - Scrollable Content
                ScrollView {
                    VStack(spacing: 20) {
                        // 프로필 이미지
                        ZStack {
                            if let displayedImage = viewModel.displayedProfileImage {
                                displayedImage
                                    .profileImageStyle()
                            } else {
                                Image("defaultAvata")
                                    .profileImageStyle()
                            }
                        }
                        .onTapGesture {
                            viewModel.showLibrary = true
                        }
                        
                        // 이름 / 태명 / 성별
                        VStack(spacing: 20) {
                            BabyInputField(
                                label: "이름 (필수)",
                                placeholder: "이름을 입력해주세요",
                                text: $viewModel.babyName,
                                focus: $focusedField,
                                field: .babyName
                            )
                            
                            BabyInputField(
                                label: "태명 (필수)",
                                placeholder: "태명을 입력해주세요",
                                text: $viewModel.babyNickname,
                                focus: $focusedField,
                                field: .babyNickname
                            )
                            
                            if viewModel.isBorn {
                                GenderSelectionView(
                                    selectedGender: $viewModel.selectedGender,
                                    segments: viewModel.availableGenderSegments,
                                    isBorn: true,
                                    onTap: { focusedField = nil }
                                )
                            } else {
                                GenderSelectionView(
                                    selectedGender: $viewModel.selectedGender,
                                    segments: viewModel.availableGenderSegments,
                                    isBorn: false,
                                    onTap: { focusedField = nil }
                                )
                            }
                        }
                        
                        // 출생일
                        BirthDateSelectionView(
                            label: viewModel.birthDateLabel,
                            showDatePicker: $viewModel.showDatePicker
                        )
                        
                        // 관계 선택
                        RelationshipSelectionView(
                            relationship: $viewModel.relationship,
                            showRelationshipPicker: $viewModel.showRelationshipPicker
                        )
                        
                        // 스크롤 끝에서 여유 공간
                        Spacer()
                            .frame(height: 24)
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.top, 16)
                }
                .scrollIndicators(.hidden)
                
                // MARK: - Bottom Save Button
                
                Button(action: {
                    viewModel.save()

                }, label: {
                    Text("저장")
                })
                .buttonStyle(!viewModel.isFormValid ? .noneButton : .defaultButton)
                .padding(.bottom, 44)
            }
            .backgroundPadding(.horizontal)
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
            .navigationBarBackButtonHidden(true)
            .background(
                Color(.systemBackground)
                    .ignoresSafeArea() // 배경만 safe area 무시
            )
            
            // MARK: - Modals
            if viewModel.showDatePicker {
                DatePickerModal(
                    birthDate: $viewModel.birthDate,
                    showDatePicker: $viewModel.showDatePicker
                )
            }
            
            if viewModel.showRelationshipPicker {
                RelationshipPickerModal(
                    relationship: $viewModel.relationship,
                    showRelationshipPicker: $viewModel.showRelationshipPicker
                )
            }
        }
        .ignoresSafeArea()
        // MARK: - Photo Picker
        .photosPicker(
            isPresented: $viewModel.showLibrary,
            selection: $imageLoaderViewModel.imageSelection,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: imageLoaderViewModel.imageToUpload) { _, newValue in
            if let newValue = newValue {
                viewModel.displayedProfileImage = Image(uiImage: newValue)
                viewModel.profileImage = newValue
            }
        }
        // MARK: - Delete Alert
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

// MARK: - Previews

#Preview("Create Mode - isBorn") {
    AddBabyStatusView(
        coordinator: BabyMoaCoordinator(),
        baby: nil,
        isBorn: true
    )
}

#Preview("Create Mode - Not Born") {
    AddBabyStatusView(
        coordinator: BabyMoaCoordinator(),
        baby: nil,
        isBorn: false
    )
}

#Preview("Edit Mode") {
    AddBabyStatusView(
        coordinator: BabyMoaCoordinator(),
        baby: AddBabyModel.mockAddBabyModel.first!,
        isBorn: true
    )
}
