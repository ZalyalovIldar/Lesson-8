//
//  UserDataManager.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 18.11.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import Foundation
import UIKit

///Data Manager of User
class UserDataManager {
    
    var userDefaults = UserDefaults.standard
    
    var coreDM = CoreDataManager()
        
    /// Method for getting User
    /// - Parameter nickname: nickname of User
    func getUser(nickname: String) -> User {
        
        return coreDM.getUser(name: "romash_only")
    }
}
