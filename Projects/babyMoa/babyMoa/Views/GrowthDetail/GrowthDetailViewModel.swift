//
//  GrowthDetailViewModel.swift
//  babyMoa
//
//  Created by 한건희 on 11/4/25.
//

import SwiftUI

@Observable
final class GrowthDetailViewModel<T: GrowthData> {
    var coordinator: BabyMoaCoordinator
    var growthDetailType: GrowthDetailType
    var babyId: Int
    var growthDataList: [T] = []
    
    init(
        coordinator: BabyMoaCoordinator,
        growthDetailType: GrowthDetailType,
        babyId: Int
    ) {
        self.coordinator = coordinator
        self.growthDetailType = growthDetailType
        self.babyId = babyId
    }
    
    func fetchSingleGrowthDetailData() async {
        switch growthDetailType {
        case .height:
            let result = await BabyMoaService.shared.getGetHeights(babyId: babyId)
            
            switch result {
            case .success(let growthListData):
                guard let listData = growthListData.data else { return }
                var tmpGrowthDataList: [T] = []
                
                
                for data in listData {
                    tmpGrowthDataList.append(Height(value: data.height, date: DateFormatter.yyyyDashMMDashdd.date(from: data.date) ?? Date(), memo: "" /*. TODO: 메모는 서버에 저장 및 불러올 수 있도록 메모 필드 추가해야 함 */) as! T)
                }
                growthDataList = tmpGrowthDataList
            case .failure(let error):
                // TODO: 에러 처리
                print(error)
            }
        case .weight:
            let result = await BabyMoaService.shared.getGetWeights(babyId: babyId)
            
            switch result {
            case .success(let growthListData):
                guard let listData = growthListData.data else { return }
                var tmpGrowthDataList: [T] = []
                
                for data in listData {
                    tmpGrowthDataList.append(Weight(value: data.weight, date: DateFormatter.yyyyDashMMDashdd.date(from: data.date) ?? Date(), memo: "" /*. TODO: 메모는 서버에 저장 및 불러올 수 있도록 메모 필드 추가해야 함 */) as! T)
                }
                growthDataList = tmpGrowthDataList
            case .failure(let error):
                // TODO: 에러 처리
                print(error)
            }
        }
        
    }
    
    func addGrowthData(value: Double, date: Date, memo: String?) async {
        let dateString = DateFormatter.yyyyDashMMDashdd.string(from: date)
        
        let result = T.self == Height.self
        ? await BabyMoaService.shared.postSetHeight(babyId: babyId, height: value, date: dateString, memo: memo)
        : await BabyMoaService.shared.postSetWeight(babyId: babyId, weight: value, date: dateString, memo: memo)
        
        switch result {
        case .success:
            print("성공적으로 저장하였습니다.") // MARK: addGrowthData의 경우 반환값 없음.
            if T.self == Height.self {
                growthDataList.append(Height(value: value, date: date, memo: memo ?? "") as! T)
                growthDataList.sort { a, b in
                    let dateA = (a as! Height).date
                    let dateB = (b as! Height).date
                    return dateA > dateB  // 최신 날짜가 앞으로 오도록
                }
            } else {
                growthDataList.append(Weight(value: value, date: date, memo: memo ?? "") as! T)
                growthDataList.sort { a, b in
                    let dateA = (a as! Weight).date
                    let dateB = (b as! Weight).date
                    return dateA > dateB  // 최신 날짜가 앞으로 오도록
                }
            }
            
            // TODO: 추가했으니, 기록 정렬 필요

        case .failure(let error):
            // TODO: 에러 처리
            print(error)
        }
    }
}

enum GrowthDetailType {
    case height
    case weight
}

protocol GrowthData: Hashable {
    var value: Double { get set }
    var date: Date { get set }
    var memo: String? { get set }
}

struct Height: GrowthData {
    var value: Double
    var date: Date
    var memo: String?
}

struct Weight: GrowthData {
    var value: Double
    var date: Date
    var memo: String?
}
