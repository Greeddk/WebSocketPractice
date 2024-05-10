//
//  CoinCombineViewModel_v2.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import Foundation
import Combine

class CoinCombineViewModel_v2: ViewModelType {

    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published
    var output = Output()
 
    init() {
        transform()
    }
    
}

extension CoinCombineViewModel_v2 {
    
    struct Input { //viewOnAppear
        var viewOnApper = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var market: Markets = []
    }
    
    enum Action {
        case viewOnAppear
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnApper.send(())
        }
    }
    
    func transform() {
        input.viewOnApper
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.fetchMarket()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchMarket() async {
        do {
            output.market = try await requestUpbitAPI()
        } catch {
            output.market = []
        }
    }
    
    private func requestUpbitAPI() async throws -> Markets {
        let url = URL(string: "https://api.upbit.com/v1/market/all")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(Markets.self, from: data)
        return result
    }
    
}
