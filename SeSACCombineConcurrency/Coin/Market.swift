//
//  Market.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import Foundation

typealias Markets = [Market]

//struct Market: Hashable, Decodable {
//    let market, koreanName, englishName: String
//    
//    enum Codingkeys: String, CodingKey {
//        case market
//        case koreanName = "korean_name"
//        case englishName = "english_name"
//    }
//}

struct Market: Hashable, Decodable {
    let market, koreanName, englishName: String
    
    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
        case englishName = "english_name"
    }
}

