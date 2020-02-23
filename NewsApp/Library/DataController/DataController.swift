//
//  DataController.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation
import Firebase

class DataController {
    
    private init() {}
    static let shared = DataController()
    
    var isFirstSetupCompleted: Bool {
        get { return UserDefaults.standard.bool(forKey: "IsFirstSetup") }

        set { UserDefaults.standard.setValue(newValue, forKey: "IsFirstSetup") }
    }
    
    var userID: String? {
        get { return UserDefaults.standard.string(forKey: "FireBaseUserID") }

        set { UserDefaults.standard.setValue(newValue, forKey: "FireBaseUserID") }
    }
}


