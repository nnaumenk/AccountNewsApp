//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class NewsViewController: WithLeftMenuViewController {

    var refreshControl = UIRefreshControl()
    var sources = [UserDataSourceModel]()
    var articles = [NewsArticleModel]()
    var page = 1
    var totalResults = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        
        view.startActivityIndicator()
        getSources(completionHandler: { [weak self] userDataModel in
            guard let self = self else { return }
            self.view.stopActivityIndicator()
            
            guard let userDataModel = userDataModel else { return }
            
            self.sources = userDataModel.sources
            self.view.startActivityIndicator()
            self.getArticles(completionHandler: { [weak self] newsResponseModel in
                guard let self = self else { return }
                self.view.stopActivityIndicator()
                
                guard let newsResponseModel = newsResponseModel else { return }
                
                self.articles += newsResponseModel.articles
                self.page += 1
                self.totalResults = newsResponseModel.totalResults
                
                self.tableView.reloadData()
            })
        })
    }
    
    @objc func refresh() {
        
        self.page = 1
        self.totalResults = -1
        self.refreshControl.beginRefreshing()
        
        getSources(completionHandler: { [weak self] userDataModel in
            guard let self = self else { return }
            
            guard let userDataModel = userDataModel else {
                self.refreshControl.endRefreshing()
                return
            }
            
            self.sources = userDataModel.sources
            self.getArticles(completionHandler: { [weak self] newsResponseModel in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                
                guard let newsResponseModel = newsResponseModel else { return }
                
                self.articles += newsResponseModel.articles
                self.page += 1
                self.totalResults = newsResponseModel.totalResults
                
                self.tableView.reloadData()
            })
        })
    }
}


extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as! NewsTableViewCell
        cell.labelTitle.text = articles[indexPath.section].title
        
        let imageView = UIImageView.init(image: UIImage.init(named: "paper"))
        imageView.contentMode = .scaleAspectFill
        
        cell.backView.insertSubview(imageView, at: 0)
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.cornerRadius = cell.backView.frame.height / 3
        cell.backView.layer.borderColor = UIColor.black.cgColor
        cell.backView.layer.masksToBounds = true
        
        loadMore(cellNumber: indexPath.section)
        
        return cell
    }
    
    private func loadMore(cellNumber: Int) {
        if tableView.tableFooterView?.numberOfCurrentQueries != 0 { return }
        if articles.isEmpty { return }
        
        if cellNumber == articles.count {
            tableView.tableFooterView?.startActivityIndicator()
            getArticles(completionHandler: { [weak self] newsResponseModel in
                guard let self = self else { return }
                self.tableView.tableFooterView?.stopActivityIndicator()
                
                guard let newsResponseModel = newsResponseModel else { return }
                
                self.articles += newsResponseModel.articles
                self.page += 1
                self.totalResults = newsResponseModel.totalResults
                
                self.tableView.reloadData()
            })
        }
    }
}

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailedNewsViewController") as? DetailedNewsViewController else { return }
        
        vc.articles = articles
        vc.articleIndex = indexPath.section
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
}


extension NewsViewController {
    
    private func getSources(completionHandler: ((UserDataModel?) -> Void)? ) {
        if let userID = DataController.shared.userID {
            
            FireBaseNetworkManager.shared.getUserData(userID: userID, completionHandler: { userDataModel in
                
                completionHandler?(userDataModel)
            })
        }
    }
    
    private func getArticles(completionHandler: ((NewsResponseModel?) -> Void)?) {
        
        if totalResults == articles.count { return }
        
        let stringURL = CONSTANTS.NEWS_API_URL + "&page=\(page)&sources=" + sources.map { $0.id }.joined(separator: ",")
        
        NetworkManager.shared.sendGETRequestResponseModel(stringURL: stringURL, completionHandler: { model in
            
            completionHandler?(model)
        })
    }
    
}
