//
//  SourcesViewController.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class SourcesViewController: WithLeftMenuViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userDataModel: UserDataModel?
    var allSources: [(source: UserDataSourceModel, isChecked: Bool)] = []
    private let group = DispatchGroup()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSources()
        getUserData()
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            guard let userDataModel = self.userDataModel else { return }
            
            self.allSources = self.allSources.map { source in
                let isChecked = userDataModel.sources.contains(where: { $0.id == source.source.id })
                return (source: source.source, isChecked: isChecked)
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func buttonSaveClicked(_ sender: Any) {
        
        if userDataModel == nil { return }
        guard let userID = DataController.shared.userID else { return }

        self.userDataModel!.sources = self.allSources.filter { $0.isChecked == true }.map { $0.source }
        
        view.startActivityIndicator()
        FireBaseNetworkManager.shared.updateUserData(userID: userID, userData: self.userDataModel!, completionHandler: { [weak self] error in
            guard let self = self else { return }
            
            self.view.stopActivityIndicator()
            if let error = error {
                self.showErrorAlert(message: error)
                return
            }
            
            self.showSuccessAlert(message: "All your data was successfully updated")
        })
    }
}

extension SourcesViewController {
    
    private func getUserData() {
        guard let userID = DataController.shared.userID else { return }
            
        group.enter()
        self.view.startActivityIndicator()
        FireBaseNetworkManager.shared.getUserData(userID: userID, completionHandler: { [weak self] (userDataModel: UserDataModel?) in
            guard let self = self else { return }
                    
            self.group.leave()
            self.view.stopActivityIndicator()
            guard let userDataModel = userDataModel else { return }
                    
            self.userDataModel = userDataModel
        })
    }
        
    private func getSources() {
        
        group.enter()
        self.view.startActivityIndicator()
        NetworkManager.shared.sendGETRequestResponseModel(stringURL: CONSTANTS.SOURCES_API_URL, completionHandler: { [weak self] (sourcesResponseModel: SourcesResponseModel?) in
            guard let self = self else { return }
                        
            self.group.leave()
            self.view.stopActivityIndicator()
            guard let sourcesResponseModel = sourcesResponseModel else { return }
            
            self.allSources = sourcesResponseModel.sources.map { (source: $0, isChecked: false) }
        })
    }
    
}

extension SourcesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sourceCheckModel = allSources[safe: indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SourcesTableViewCell") as? SourceTableViewCell else { return UITableViewCell() }
        
        cell.imageCheckBox.isHidden = !sourceCheckModel.isChecked
        cell.sourceName.text = sourceCheckModel.source.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? SourceTableViewCell else { return }
        
        allSources[safe: indexPath.row]?.isChecked.toggle()
        cell.imageCheckBox.isHidden.toggle()
    }
}

