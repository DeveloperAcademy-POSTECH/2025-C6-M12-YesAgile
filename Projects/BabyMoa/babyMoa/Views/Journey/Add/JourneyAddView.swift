//
//  JourneyAddView.swift
//  BabyMoaJourney
//
//  Created by pherd on 11/7/25.
//
import CoreLocation
import PhotosUI
import SwiftUI
//
//struct JourneyAddView: View {
//    @State var viewModel: JourneyAddViewModel
//    let onDismiss: () -> Void
//
//    @Environment(\.dismiss) private var dismiss
//    @State private var showImagePicker = false
//    @State private var pickedItem: PhotosPickerItem? = nil
//    @FocusState private var isMemoFocused: Bool
//
//    // Simplified init
//    init(viewModel: JourneyAddViewModel, onDismiss: @escaping () -> Void) {
//        self._viewModel = State(initialValue: viewModel)
//        self.onDismiss = onDismiss
//    }
//
//    var body: some View {
//        ZStack {
//            Color.background.ignoresSafeArea()
//
//            VStack(spacing: 0) {
//                CustomNavigationBar(
//                    title: viewModel.navigationTitle,
//                    leading: {
//                        Button(action: {
//                            endTextEditing()
//                            onDismiss()
//                        }) {
//                            Image(systemName: "chevron.left")
//                        }
//                    }
//                )
//                .padding(.horizontal, 20)
//
//                // Limited access banner can be its own view, but for now this is fine.
//                // We need `photoAccessStatus` from somewhere, maybe the parent VM.
//                // For now, let's remove it to proceed with structural refactoring.
//                
//                ScrollView {
//                    VStack(spacing: 20) {
//                        photoSection
//                            .padding(.horizontal, 20)
//                            .padding(.top, 8)
//                        
//                        memoSection
//                            .padding(.horizontal, 20)
//
//                        Spacer()
//
//                        saveButton
//                            .padding(.horizontal, 20)
//                            .padding(.bottom, 30)
//                    }
//                    .padding(.bottom, 44)
//                }
//                .scrollDismissesKeyboard(.interactively)
//            }
//        }
//        .ignoresSafeArea(edges: .top)
//        .onTapGesture(perform: endTextEditing)
//        .photosPicker(isPresented: $showImagePicker, selection: $pickedItem, matching: .images, preferredItemEncoding: .current)
//        .onChange(of: pickedItem) { _, newValue in
//            viewModel.handleImageSelection(newValue)
//        }
//        .alert("위치 정보 없음", isPresented: $viewModel.showLocationAlert) {
//            Button("확인", role: .cancel) {}
//        } message: {
//            Text("사진에 위치 정보가 없어서 지도 위에 보이지 않습니다.")
//        }
//        .alert("사진 로드 실패", isPresented: $viewModel.showLoadErrorAlert) {
//            Button("확인", role: .cancel) {}
//        } message: {
//            Text(viewModel.loadErrorMessage)
//        }
//    }
//
//    private var photoSection: some View {
//        ZStack {
//            if let image = viewModel.selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(maxWidth: .infinity)
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                    .transition(.opacity.combined(with: .scale))
//            } else {
//                placeholderView
//            }
//        }
//        .contentShape(Rectangle())
//        .onTapGesture {
//            withAnimation(.spring) { showImagePicker = true }
//        }
//        .animation(.spring, value: viewModel.selectedImage)
//    }
//    
//    private var memoSection: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("여정 메모")
//                .labelTextStyle()
//            
//            ZStack(alignment: .topLeading) {
//                TextEditor(text: $viewModel.memo)
//                    .focused($isMemoFocused)
//                    .scrollContentBackground(.hidden)
//                    .font(.system(size: 14))
//                    .frame(height: 150)
//                    .padding(12)
//                    .background(Color.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 12)
//                            .stroke(Color.brand40, lineWidth: 1)
//                    )
//                
//                if viewModel.memo.isEmpty {
//                    Text("아이와 함께한 소중한 여정 메모를 입력 해주세요")
//                        .font(.system(size: 14))
//                        .foregroundColor(Color.gray.opacity(0.6))
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 20)
//                        .allowsHitTesting(false)
//                }
//            }
//        }
//    }
//    
//    private var saveButton: some View {
//        Button("저장") {
//            viewModel.save()
//            endTextEditing()
//            onDismiss()
//        }
//        .buttonStyle(viewModel.isSaveDisabled ? .noneButton : .defaultButton)
//        .frame(height: 56)
//        .disabled(viewModel.isSaveDisabled)
//    }
//
//    private var placeholderView: some View {
//        RoundedRectangle(cornerRadius: 16, style: .continuous)
//            .fill(Color.white)
//            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.white))
//            .overlay(
//                VStack(spacing: 10) {
//                    Image(systemName: "photo.on.rectangle")
//                        .font(.system(size: 36, weight: .medium))
//                        .foregroundColor(Color.brand40)
//                    Text("아이와 함께한 소중한 여정 사진을 등록 해주세요")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal, 20)
//                }
//            )
//            .frame(height: 265)
//    }
//}
//
//struct LimitedAccessBanner: View {
//    let onSettingsTap: () -> Void
//
//    var body: some View {
//        HStack(spacing: 12) {
//            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
//            Text("위치 정보를 사용할 수 없습니다. 맵 위에는 보이지 않아요.").font(.system(size: 14, weight: .semibold)).lineLimit(2)
//            Spacer()
//            Button("설정", action: onSettingsTap).font(.system(size: 14, weight: .medium)).foregroundColor(.blue)
//        }
//        .padding(12)
//        .background(Color.orange.opacity(0.1))
//        .cornerRadius(12)
//    }
//}
