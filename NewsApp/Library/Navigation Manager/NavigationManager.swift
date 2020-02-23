//
//  NavigationManager.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

final class NavigationManager {
    
    private var newsNVC: UINavigationController?
    private var sourcesNVC: UINavigationController?
    private var weatherNVC: UINavigationController?
    private var profileNVC: UINavigationController?
    
    private init() {}
    static let shared = NavigationManager()
    
    func openRegistrationVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registrationViewController")
        setRootVC(vc: vc)
    }
    
    func openFirstSetupVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setUpViewController")
        setRootVC(vc: vc)
    }
    
    func openNewsVC() {
        if newsNVC == nil {
            initAllVC()
        }
        
        setRootVC(vc: newsNVC!)
    }
    
    func openSourcesVC() {
        setRootVC(vc: sourcesNVC!)
    }
    
    func openWeatherVC() {
        setRootVC(vc: weatherNVC!)
    }
    
    func openProfileVC() {
        setRootVC(vc: profileNVC!)
    }
    
    func logout() {
        DataController.shared.userID = nil
        DataController.shared.isFirstSetupCompleted = false
        
        deinitAllVC()
        openRegistrationVC()
    }
}

extension NavigationManager {
    
    private func setRootVC(vc: UIViewController) {
        
        if (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController === vc { return }
        if ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController).self == vc.self { return }
        print("2")
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = vc
    }
    
    private func initAllVC() {
        
        newsNVC = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newsViewController"))
        
        sourcesNVC = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sourcesViewController"))
        
        weatherNVC = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "weatherViewController"))
        
        profileNVC = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController"))
    }
    
    private func deinitAllVC() {
        newsNVC = nil
        sourcesNVC = nil
        weatherNVC = nil
        profileNVC = nil
    }
}
