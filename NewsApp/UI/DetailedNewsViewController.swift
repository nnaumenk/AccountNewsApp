//
//  DetailedNewsViewController.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class DetailedNewsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelAuthorDate: UILabel!
    @IBOutlet weak var textViewTitle: UITextView!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var buttonPrev: UIBarButtonItem!
    @IBOutlet weak var buttonNext: UIBarButtonItem!
    
    var articles: [NewsArticleModel]!
    var articleIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestures()
        manageButtons()
        setData()
    }
    
    @objc func swipeHandler(gesture: UIGestureRecognizer) {
        
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else { return }

        switch swipeGesture.direction {

        case .right:
            if buttonPrev.isEnabled { buttonPrevClicked(nil) }
        case .left:
            if buttonNext.isEnabled{ buttonNextClicked(nil) }
            
        default:
            break
        }
    }
    
    
    @IBAction func buttonPrevClicked(_ sender: Any?) {
        
        articleIndex -= 1
        manageButtons()
        setData()
    }
    
    @IBAction func buttonNextClicked(_ sender: Any?) {
        
        articleIndex += 1
        manageButtons()
        setData()
    }
    
    private func addGestures() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    private func manageButtons() {
    
        if articleIndex == 0 {
            buttonPrev.isEnabled = false
        } else { buttonPrev.isEnabled = true }

        if articleIndex == articles.count - 1 {
            buttonNext.isEnabled = false
        } else { buttonNext.isEnabled = true }
    
    }
    
    private func setData() {
        
        let article = articles[articleIndex]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy HH:mm"
        
        let dateString: String
        if let articleDate = article.publishedAt {
            if let date = dateFormatterGet.date(from: articleDate) {
                dateString = dateFormatterPrint.string(from: date)
            } else { dateString = "" }
        } else { dateString = "" }
        
        if let author = article.author {
            labelAuthorDate.text = author + " • " + dateString
        } else {
            labelAuthorDate.text = dateString
        }
        
        let imageURL: String
        if let urlToImage = article.urlToImage {
            if urlToImage.contains("http") {
                imageURL = urlToImage
            } else { imageURL = "http:" + urlToImage }
        } else {imageURL = ""}
        
        if !imageURL.isEmpty {
            imageView.imageFromURL(urlString: imageURL, completionHandler: nil)
        }
        textViewTitle.text = article.title
        textViewDescription.text = article.description
    }

}
