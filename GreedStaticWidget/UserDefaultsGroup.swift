//
//  UserDefaultsGroup.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/13/24.
//

import Foundation

extension UserDefaults {
    
    static var groupShared: UserDefaults {
        let appGroupID = "group.sesac.greed.wallet"
        return UserDefaults(suiteName: appGroupID)!
    }
    
    
}
