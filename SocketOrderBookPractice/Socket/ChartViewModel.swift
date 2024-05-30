//
//  ChartViewModel.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/10/24.
//

import Foundation
import Combine

final class ChartViewModel: ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    
    @Published
    var askOrderBook: [OrderBookItem] = []
    
    @Published
    var bidOrderBook: [OrderBookItem] = []
    
    init() {
        WebSocketManager.shared.openWebSocket()
        
        WebSocketManager.shared.send(
        """
        [{"ticket":"test"},{"type":"orderbook","codes":["KRW-BTC"]}]
        """
        )
        
        WebSocketManager.shared.orderbookSbj
            .sink { [weak self] order in
                guard let self else { return }
                dump(order)
                self.askOrderBook = order.orderbook_units
                    .map {
                        .init(price: $0.ask_price, size: $0.ask_size)
                    }
                    .sorted {
                        $0.price > $1.price
                    }
                
                self.bidOrderBook = order.orderbook_units
                    .map {
                        .init(price: $0.bid_price, size: $0.bid_size)
                    }
                    .sorted {
                        $0.price > $1.price
                    }
            }
            .store(in: &cancellable)
    }
    
    deinit {
        WebSocketManager.shared.closeWebSocket()
    }
    
}
