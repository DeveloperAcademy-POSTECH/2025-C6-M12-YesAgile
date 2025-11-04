//
//  AddBabyStatusView.swift
//  babyMoa
//
//  Created by Baba on 11/4/25.
//

import SwiftUI

class AddBabyStatusViewModel: ObservableObject {
    @Published var babyName: String = ""
    @Published var babyNickname: String = ""
    @Published var selectedGender: String = "" // Or an enum for gender
}

struct AddBabyStatusView: View {
    @StateObject var viewModel = AddBabyStatusViewModel()
    
    //MARK: - 아기 정보에 대해 입력하는 TextField
    fileprivate func BabyInputField(label: String, placeholder: String, text: Binding<String>) -> some View{
        VStack(alignment: .leading) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.font)
            TextField(placeholder, text: text)
                .textFieldStyle(.basicForm)
        }
    }
    
    //MARK: - 아기 성별을 선택하는 버튼
    fileprivate func GenderSelectionView(selectedGender: Binding<String>) -> some View{
        VStack(alignment: .leading){
            Text("성별")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.font)
            
            HStack {
                Picker("성별", selection: selectedGender) {
                    Text("남자").tag("M")
                    Text("여자").tag("F")
                    Text("미정").tag("none")

                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }

    
    
    @State private var isBorn: Bool = true
    
    var body: some View {
        
        VStack(spacing: 20) {
            //
            CustomNavigationBar(title: "설정", leading: {
                Button(action: { }) {
                    Image(systemName: "chevron.left")
                }
            })
            
            
            // Profile Image Section -----
            
            Rectangle()
                .frame(width: 100, height: 100)
            
            VStack(spacing: 20){
                if isBorn {
                    BabyInputField(label: "이름 (필수)", placeholder: "이름을 입력해주세요", text: $viewModel.babyName)
                    BabyInputField(label: "태명 (선택)", placeholder: "태명을 입력해주세요", text: $viewModel.babyNickname)
                    GenderSelectionView(selectedGender: $viewModel.selectedGender)
                } else {
                    BabyInputField(label: "이름 (선택)", placeholder: "이름을 입력해주세요", text: $viewModel.babyName)
                    BabyInputField(label: "태명 (필수)", placeholder: "태명을 입력해주세요", text: $viewModel.babyNickname)
                }
            }
            
            Spacer()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .backgroundPadding(.horizontal)
        
    }
    
    
}

#Preview {
    AddBabyStatusView()
}
