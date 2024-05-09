//
//  ChartView.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import SwiftUI

struct ChartView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                WebSocketManager.shared.openWebSocket()
                
                WebSocketManager.shared.send(
                """
                [{"ticket":"test"},{"type":"orderbook","codes":["KRW-BTC"]}]
                """
                )
            }
    }
}

#Preview {
    ChartView()
}
