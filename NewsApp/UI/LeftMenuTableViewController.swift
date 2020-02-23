//
//  LeftMenuTableViewController.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class LeftMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Меню"
        self.tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        
        case 0:
            NavigationManager.shared.openNewsVC()
        case 1:
            NavigationManager.shared.openSourcesVC()
        case 2:
            NavigationManager.shared.openWeatherVC()
        case 3:
            NavigationManager.shared.openProfileVC()
        case 4:
            NavigationManager.shared.logout()
            
        default:
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
