//
//  WithLeftMenuViewController.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit
import SideMenu

class WithLeftMenuViewController: UIViewController {

    private let leftMenuNVC: UISideMenuNavigationController = {
        let nvc = UISideMenuNavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leftMenuViewController"))
        nvc.leftSide = true
        return nvc
    }()
    
    private lazy var leftMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(showLeftMenu), for: .touchUpInside)
        button.setImage(UIImage(named: "navigation2"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftMenuButton)
        
        let leftToRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        leftToRightSwipe.direction = .right
        view.addGestureRecognizer(leftToRightSwipe)
    }
    
    @objc private func swipeHandler(gesture: UIGestureRecognizer) {
//        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else { return }
        
        present(leftMenuNVC, animated: true, completion: nil)
    }
    
    @objc private func showLeftMenu() {
        present(leftMenuNVC, animated: true, completion: nil)
    }

}
