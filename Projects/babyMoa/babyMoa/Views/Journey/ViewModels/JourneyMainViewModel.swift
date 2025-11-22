import SwiftUI
import Combine

@MainActor
@Observable
final class JourneyMainViewModel {
    // MARK: - Properties
    var currentBabyId: Int?
    var journeys: [Journey] = []
    var selectedDate: Date = Date()
    var errorMessage: String?
    var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let repository: JourneyRepository
    let coordinator: BabyMoaCoordinator
    
    // MARK: - Initialization
    init(
        coordinator: BabyMoaCoordinator,
        repository: JourneyRepository = .shared
    ) {
        self.coordinator = coordinator
        self.repository = repository
        
        // 아기 변경 감지
        SelectedBabyState.shared.$baby
            .receive(on: DispatchQueue.main)
            .sink { [weak self] baby in
                guard let self = self else { return }
                
                if let baby = baby {
                    // 아기가 변경되었으면 데이터 새로고침
                    self.handleBabyChanged(babyId: baby.babyId)
                } else {
                    // 아기 선택 해제 시 초기화
                    self.journeys = []
                    self.currentBabyId = nil
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Baby Change Handling
    private func handleBabyChanged(babyId: Int) {
        // 아기가 실제로 변경되었을 때만 로드 (초기 로드 포함)
        if currentBabyId != babyId {
            currentBabyId = babyId
            Task {
                await self.fetchJourneys()
            }
        }
    }
    
    // MARK: - Data Fetching
    func fetchJourneys() async {
        
        guard let babyId = currentBabyId else { return }
        guard !isLoading else { return }
        
        isLoading = true
        defer { 
            isLoading = false 
        }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        
        // 1. Repository에서 데이터 가져오기 (캐싱 적용됨)
        let fetchedJourneys = await repository.fetchJourneys(
            babyId: babyId,
            year: year,
            month: month
        )
        
        // 2. 이미지 다운로드 로직 제거 (Lazy Loading 적용)
        // 이제 View에서 CachedAsyncImage를 통해 필요할 때 로드합니다.
        
        self.journeys = fetchedJourneys
    }
    
    /// Phase 1.5: 특정 월의 여정만 갱신 (Add/Update 후 사용)
    /// - 다른 월의 데이터는 유지하여 불필요한 네트워크 요청 방지
    private func fetchJourneysForMonth(year: Int, month: Int) async {
        guard let babyId = currentBabyId else { return }
        
        // 1. Repository에서 해당 월 데이터 가져오기
        let fetchedJourneys = await repository.fetchJourneys(
            babyId: babyId,
            year: year,
            month: month
        )
        
        // 2. 기존 journeys에서 해당 월만 교체
        let calendar = Calendar.current
        self.journeys.removeAll { journey in
            let y = calendar.component(.year, from: journey.date)
            let m = calendar.component(.month, from: journey.date)
            return y == year && m == month
        }
        self.journeys.append(contentsOf: fetchedJourneys)
    }
    
    // MARK: - Actions
    
    func addJourney(image: UIImage, memo: String, date: Date, latitude: Double, longitude: Double) async -> Bool {
        guard let babyId = currentBabyId else { return false }
        
        // 1. Optimistic UI: 임시 객체 생성 및 즉시 추가
        let tempId = UUID()
        let tempJourney = Journey(
            id: tempId,
            journeyId: 0, // 임시 ID (0)
            journeyImage: image,
            imageUrl: nil,
            latitude: latitude,
            longitude: longitude,
            date: date,
            memo: memo,
            isTemporary: true
        )
        
        self.journeys.append(tempJourney)
        
        // 2. 백그라운드에서 서버 저장
        let success = await repository.addJourney(
            babyId: babyId,
            image: image,
            latitude: latitude,
            longitude: longitude,
            date: date,
            memo: memo
        )
        
        if success {
            // 3. 성공 시: 서버 데이터 fetch 및 교체 (Silent Swap)
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            
            let fetchedJourneys = await repository.fetchJourneys(
                babyId: babyId,
                year: year,
                month: month
            )
            
            // 해당 월의 기존 데이터(임시 포함)를 모두 제거하고 서버 데이터로 교체
            // 단, 방금 추가한 임시 객체의 이미지를 유지하기 위해 매칭 로직 수행
            
            self.journeys.removeAll { journey in
                let y = calendar.component(.year, from: journey.date)
                let m = calendar.component(.month, from: journey.date)
                return y == year && m == month
            }
            
            for var journey in fetchedJourneys {
                // 방금 추가한 항목인지 확인 (날짜와 메모로 추정)
                if calendar.isDate(journey.date, inSameDayAs: date) && journey.memo == memo {
                    journey.journeyImage = image // 로컬 이미지 재사용 (URL 로딩 없이 즉시 표시)
                    // 만약 이전 임시 객체를 찾고 싶다면 여기서 UUID 매칭은 불가능(서버는 UUID 모름)하지만
                    // UX상으로는 이미지가 깜빡이지 않으면 충분함
                }
                self.journeys.append(journey)
            }
            
        } else {
            // 4. 실패 시: 임시 객체 삭제 (Rollback)
            if let index = self.journeys.firstIndex(where: { $0.id == tempId }) {
                self.journeys.remove(at: index)
            }
        }
        
        return success
    }
    
    func updateJourney(journey: Journey, image: UIImage, memo: String, latitude: Double, longitude: Double) async -> Bool {
        guard let babyId = currentBabyId else { return false }
        
        // 1. Optimistic UI: 즉시 로컬 업데이트 (백업해둠)
        var originalJourney: Journey?
        if let index = journeys.firstIndex(where: { $0.journeyId == journey.journeyId }) {
            originalJourney = journeys[index]
            // 로컬 데이터 즉시 변경
            journeys[index].journeyImage = image
            journeys[index].memo = memo
            journeys[index].latitude = latitude
            journeys[index].longitude = longitude
            journeys[index].isTemporary = true // 업데이트 중 표시 (선택 사항)
        }
        
        // 2. 백그라운드에서 서버 업데이트
        let success = await repository.updateJourney(
            babyId: babyId,
            journeyId: journey.journeyId,
            image: image,
            latitude: latitude,
            longitude: longitude,
            date: journey.date,
            memo: memo
        )
        
        if success {
            // 3. 성공 시: 서버 데이터 fetch 및 교체
            let calendar = Calendar.current
            let year = calendar.component(.year, from: journey.date)
            let month = calendar.component(.month, from: journey.date)
            
            let fetchedJourneys = await repository.fetchJourneys(
                babyId: babyId,
                year: year,
                month: month
            )
            
            // 기존 항목 제거 및 교체
            journeys.removeAll { j in
                let y = calendar.component(.year, from: j.date)
                let m = calendar.component(.month, from: j.date)
                return y == year && m == month
            }
            
            for var j in fetchedJourneys {
                if j.journeyId == journey.journeyId {
                    j.journeyImage = image  // 기존 이미지 재사용
                }
                journeys.append(j)
            }
            
        } else {
            // 4. 실패 시: 롤백 (원래 데이터로 복원)
            if let original = originalJourney,
               let index = journeys.firstIndex(where: { $0.journeyId == original.journeyId }) {
                journeys[index] = original
            }
        }
        
        return success
    }
    
    func deleteJourney(_ journey: Journey) async -> Bool {
        guard let babyId = currentBabyId else { return false }
        
        let success = await repository.deleteJourney(babyId: babyId, journeyId: journey.journeyId)
        
        if success {
            // 로컬 삭제 (UI 반응성 향상)
            if let index = journeys.firstIndex(where: { $0.id == journey.id }) {
                journeys.remove(at: index)
            }
        }
        return success
    }
    
    // 날짜 변경 시 호출
    func updateDate(_ date: Date) {
        let oldComponents = Calendar.current.dateComponents([.year, .month], from: selectedDate)
        let newComponents = Calendar.current.dateComponents([.year, .month], from: date)
        
        self.selectedDate = date
        
        if oldComponents != newComponents {
            Task {
                await fetchJourneys()
            }
        }
    }
}

