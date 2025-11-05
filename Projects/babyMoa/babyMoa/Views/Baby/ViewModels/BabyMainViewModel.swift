//
//  BabyMainViewModel.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import Foundation

class BabyMainViewModel: ObservableObject {
    
    @Published var babies : [Babies] = []
    @Published var isShowingSheet: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(){
        Task {
            await fetchBabies()
        }
    }
    
    func fetchBabies() async {
        isLoading = true
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
            
            // (2) 나중에 이 자리에 실제 네트워크 코드가 들어갑니다.
            // let decodedData = try await NetworkService.fetch(...)
            
            // (3) 성공 시 (에러가 없었을 때)
            self.babies = Babies.mockBabies
            self.errorMessage = nil
            
        } catch {
            
            print("아기 데이터를 가져오는데 실패했습니다 \(error.localizedDescription)")
            self.errorMessage = "데이터를 불러오는데 실패 했습니다. "
        }
        
        isLoading = false
    }
    
    func showBabyListSheet(){
        isShowingSheet  = true
    }
}
