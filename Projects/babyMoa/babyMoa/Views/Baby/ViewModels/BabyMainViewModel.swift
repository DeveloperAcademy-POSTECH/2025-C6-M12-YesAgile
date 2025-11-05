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
    @Published var showSignOutAlert: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private func createAlert(title:String, message: String){
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    init(){
        Task {
            await fetchBabies()
        }
    }
    
    func signOut() -> Bool {
        do {
            
            // SignOut 함수를 만들어야 한다.
            // 어떻게 해야 되는지 서버와 이야기 해야 한다. 
            
            return true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            return false
        }
    }
    
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
            createAlert(title: "네트워크 오류 발생", message: "아기 데이터를 가져오는데 실패했습니다.")
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
