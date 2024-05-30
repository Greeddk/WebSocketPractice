//
//  RowView.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import SwiftUI

struct RowView: View {
    
    let data: Market
    
    var body: some View {
        VStack {
            Text(data.koreanName)
                .fontWeight(.bold)
            Text(data.market)
                .font(.caption)
                .foregroundStyle(.gray)
            Text(data.englishName)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow)
    }
}

#Preview {
    RowView(data: Market(market: "비트코인", koreanName: "비트코인", englishName: "bitcoin"))
}
