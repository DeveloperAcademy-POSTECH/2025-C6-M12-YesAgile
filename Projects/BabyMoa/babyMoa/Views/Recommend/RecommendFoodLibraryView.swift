//
//  RecommendFoodLibraryView.swift
//  babyMoa
//
//  Created by Baba on 10/30/25.
//

import SwiftUI

struct RecommendFoodLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var foodLibrary: FoodLibrary
    @Binding var selectedItem: FoodLibraryItem?
    @State private var searchText = ""
    @State var selectedAgeRange = "6-8개월"
    
    // 이것은 추후에 모델로 옮기던지 뷰 모델로 이동해야 한다.
    private let ageRanges = ["6-8개월", "8-10개월", "10-12개월"]
    
    // filter Food 음식 검색을 위한 계산 프로퍼티를 만들어야 한다.
    var filteredFoods: [FoodLibraryItem] {
        let ageFiltered = foodLibrary.getFoodsForAge(selectedAgeRange)
        if searchText.isEmpty {
            return ageFiltered
        } else {
            return ageFiltered.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
    var body: some View {
        VStack{
            VStack{
                
                TextField("음식 검색...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Picker("연령 범위", selection: $selectedAgeRange) {
                    // ForEach을 이용해서 데이터를 보여준다.
                    ForEach(ageRanges, id:\.self) { range in
                        Text(range).tag(range)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                
            }
            .padding(.horizontal)  // padding 의 높이는 추후에 디자인 보고 수정해야 한다.
            .padding(.vertical)
            
            // Food List을 들어가야 하는 곳
            // List 형태로 들어가야 한다.
            // data을 만들어서 가져와야 한다. 이것은 추천하는 음식이기 떄문입니다.
            // 추천 음식 관리 데이터를 만든다. (목업 또는 가져오는 데이타)
            
            List(filteredFoods) { item in
                FoodLibrayView(item: item) {
                    selectedItem = item
                    dismiss()
                }
            }
            
            Spacer()
        }
        .background(Color.gray.opacity(0.2))  // 배경색은 피그마 또는 칼라칩에서 확인해야 한다.

    }
}

#Preview {
    RecommendFoodLibraryView(
        foodLibrary: FoodLibrary(), // FoodLibrary()가 음식 데이터를 로드한다고 가정
        selectedItem: .constant(nil) // .constant를 사용해 임시 바인딩 제공
    )
}
