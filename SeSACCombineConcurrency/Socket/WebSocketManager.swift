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
    
    func openWebSocket() {
        if let url = URL(string: "wss://api.upbit.com/websocket/v1") {
            
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            
            websocket = session.webSocketTask(with: url)
            websocket?.resume()
        }
    }
    
    func closeWebSocket() {
        websocket?.cancel(with: .goingAway, reason: nil)
        websocket = nil
        
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
                    print("--------------", success)
                case .failure(let failure):
                    print(failure)
                }
                self.receiveSocketData()
            })
        }
    }
    
}
