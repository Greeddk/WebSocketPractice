//
//  CoinView.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import SwiftUI

enum NetworkError: Error {
    case invalidResponse
    case unknown
    case invalidImage
}

struct CoinView: View {
    
    @State private var market: Markets = []
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
//    [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(market, id: \.market) { item in
                        RowView(data: item)
                    }
                }
            } //ScrollView
            .task {
                do {
                    market = try await fetchMarket()
                } catch {
                    market = []
                }
            }
//            .onAppear {
//                Task {
//                    do {
//                        market = try await fetchMarket()
//                    } catch {
//                        market = []
//                    }
//                }
//            }
            
        } //NavigationStack
    }
    
    func fetchMarket() async throws -> Markets {
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

#Preview {
    CoinView()
}
