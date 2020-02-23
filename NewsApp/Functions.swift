//
//  Functions.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 8/10/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation

private func readSources() {
    let user = DataController.user
    
    let db = Firestore.firestore()
    let doc = db.collection("users").document(user!.uid)
    
    doc.getDocument { (document, error) in
        if let document = document, document.exists {
            guard let dic = document.data() else { return }
            
            guard let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) else { return }
            
            let userData = try! JSONDecoder().decode(UserData.self, from: data)
            
            self.mySources = userData.sources
            self.gotAllInfo()
        }
    }
}
