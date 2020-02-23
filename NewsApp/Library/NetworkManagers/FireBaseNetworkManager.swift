//
//  FireBaseNetworkManager.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit
import FirebaseAnalytics

final class FireBaseNetworkManager {

    private init() {}
    static let shared = FireBaseNetworkManager()
 
    func signUp(email: String, password: String, completionHandler: ((String?, String?) -> Void)? ) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            completionHandler?(authResult?.user.uid, error?.localizedDescription)
        }
    }
    
    func signIn(email: String, password: String, completionHandler: ((String?, String?) -> Void)? ) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    
            completionHandler?(authResult?.user.uid, error?.localizedDescription)
        }
    }
    
    func updatePassword(newPassword: String, completionHandler: ((String?) -> Void)? ) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            
            completionHandler?(error?.localizedDescription)
        }
    }
    
    func getUserData(userID: String, completionHandler: ((UserDataModel?) -> Void)?) {
        Firestore.firestore().collection("users").document(userID).getDocument { (document, error) in
            
            guard let userData = self.parseUserData(document: document) else {
                completionHandler?(nil)
                return
            }
            
            completionHandler?(userData)
        }
    }
    
    func createUserData(userID: String, userData: UserDataModel, completionHandler: ((String?) -> Void)?) {
        guard let dict = userData.dictionary else {
            completionHandler?("Some error occured")
            return
        }
        
        Firestore.firestore().collection("users").document(userID).setData(dict, completion: { error in
            guard let error = error else {
                completionHandler?(nil)
                return
            }
            
            completionHandler?(error.localizedDescription)
        })
    }
    
    func updateUserData(userID: String, userData: UserDataModel, completionHandler: ((String?) -> Void)?) {
        guard let dict = userData.dictionary else {
            completionHandler?("Some error occured")
            return
        }
        
        Firestore.firestore().collection("users").document(userID).updateData(dict, completion: { error in
            guard let error = error else {
                completionHandler?(nil)
                return
            }
            
            completionHandler?(error.localizedDescription)
        })
    }
}

extension FireBaseNetworkManager {
    
    private func parseUserData(document: DocumentSnapshot?) -> UserDataModel? {
        guard let document = document else { return nil }
        if !document.exists { return nil }
        guard let dict = document.data() else { return nil }
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else { return nil }
        guard let userData = try? JSONDecoder().decode(UserDataModel.self, from: data) else { return nil }

        return userData
    }
    
}
