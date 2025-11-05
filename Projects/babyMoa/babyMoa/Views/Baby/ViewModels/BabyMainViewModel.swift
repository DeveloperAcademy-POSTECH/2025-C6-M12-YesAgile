//
//  BabyMainViewModel.swift
//  babyMoa
//
//  Created by Baba on 11/5/25.
//

import Foundation

class BabyMainViewModel: ObservableObject {
    
    @Published var babies : [Babies] = []
    @Published var selectedBaby: Babies?
    @Published var isShowingSheet: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(){
        Task {
            await fetchBabies()
        }
    }
    
    @MainActor
    func fetchBabies() async {
        isLoading = true
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
            
            let fetchedBabies = Babies.mockBabies
            self.babies = fetchedBabies
            self.selectedBaby = fetchedBabies.first
            self.errorMessage = nil
            
        } catch {
            
            print("아기 데이터를 가져오는데 실패했습니다 \(error.localizedDescription)")
            self.errorMessage = "데이터를 불러오는데 실패 했습니다. "
        }
        
        isLoading = false
    }
    
    func selectBaby(_ baby: Babies) {
        self.selectedBaby = baby
        self.isShowingSheet = false
    }
    
    func showBabyListSheet(){
        isShowingSheet  = true
    }
}
