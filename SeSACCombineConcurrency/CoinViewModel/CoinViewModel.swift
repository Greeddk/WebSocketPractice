//
//  CoinViewModel.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import Foundation

class CoinViewModel: ObservableObject {
    
    @Published var market: Markets = []
    
    func fetchMarket() async throws {
        do {
            market = try await requestUpbitAPI()
        } catch {
            market = []
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
