//
//  Network.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import Foundation

final class Network {
    static let shared = Network()
    
    private init() { }
    
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
