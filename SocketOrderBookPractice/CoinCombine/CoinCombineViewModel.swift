//
//  CoinCombineViewModel.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import Foundation
import Combine
//DisposeBag - AnyCancellable

//subscribe - sink
//dispose - store

//observeOn - receiveOn

//observable - observer - operator
//Publisher - Subscriber - Operator

//publishSubject -> PassthroughSubject
//behaviorSubject -> CurrentValueSubject
class CoinCombineViewModel: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published 
    var output = Output()
 
    struct Input { //viewOnAppear
        var viewOnApper = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var market: Markets = []
    }
    
    init() {
        transform()
    }
    
    func transform() {
        input.viewOnApper
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    try? await self.fetchMarket()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchMarket() async throws {
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
