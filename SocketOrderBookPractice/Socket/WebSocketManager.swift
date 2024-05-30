//
//  WebSocketManager.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import Foundation
import Combine

final class WebSocketManager: NSObject { //URLSessionWebSocketDelegate를 타고 들어가다보면 NSObjectProtocol을 채택하고 있어서 채택이 필요
    
    static let shared = WebSocketManager()
    
    private var websocket: URLSessionWebSocketTask?
    private var isOpen = false
    
    var orderbookSbj = PassthroughSubject<OrderBook, Never>()
    
    var timer: Timer?
    
    func openWebSocket() {
        if let url = URL(string: "wss://api.upbit.com/websocket/v1") {
            
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            
            websocket = session.webSocketTask(with: url)
            websocket?.resume()
            
            ping()
        }
    }
    
    func closeWebSocket() {
        websocket?.cancel(with: .goingAway, reason: nil)
        websocket = nil
        
        timer?.invalidate()
        timer = nil
        
        isOpen = false
    }
    
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Socket Open")
        isOpen = true
        receiveSocketData()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Socket Closed")
        isOpen = false
    }
    
}

extension WebSocketManager {
    
    func send(_ string: String) {
        websocket?.send(URLSessionWebSocketTask.Message.string(string), completionHandler: { error in
            print("Send Error")
        })
    }
    
    //재귀적인 구조로 구성이 되어야 계속해서 데이터를 수신할 수 있음.
    func receiveSocketData() {
        
        if isOpen {
            websocket?.receive(completionHandler: { result in
                switch result {
                case .success(let success):
                    
                    switch success {
                    case .data(let data):
                        
                        if let decodedData = try? JSONDecoder().decode(OrderBook.self, from: data) {
                            dump(decodedData)
                            
                            self.orderbookSbj.send(decodedData)
                        }
                        
                    case .string(let string): print(string)
                    @unknown default:
                        print("Unknown Default")
                    }
                    
                case .failure(let failure):
                    print(failure)
                }
                self.receiveSocketData()
            })
        }
    }
    
    // 서버에 의해 연결이 끊어지지 않도록 주기적으로 ping을 서버에 보내주는 작업도 추가
    func ping() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.websocket?.sendPing(pongReceiveHandler: { error in
                if let error = error {
                    print("ping pong error", error.localizedDescription)
                } else {
                    print("ping ping ping")
                }
            })
        }
    }
    
}
