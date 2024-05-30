//
//  CoinUpgradeView.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import SwiftUI

struct CoinUpgradeView: View {
    
    @StateObject var viewModel = CoinViewModel()
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
//    [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.market, id: \.market) { item in
                        RowView(data: item)
                    }
                }
            } //ScrollView
            .task {
                try? await viewModel.fetchMarket()
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
    
}

#Preview {
    CoinUpgradeView()
}
