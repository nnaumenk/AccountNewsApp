//
//  UIImageView.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func imageFromURL(urlString: String, completionHandler: ((UIImage?) -> Void)? ) {
    
        self.image = nil
        self.startActivityIndicator()
        
        NetworkManager.shared.sendGETRequestResponseData(stringURL: urlString, completionHandler: { [weak self] data in
            guard let self = self else { return }
            self.stopActivityIndicator()
     
            guard let data = data else {
                completionHandler?(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                completionHandler?(nil)
                return
            }
            
            self.image = image
            completionHandler?(image)
        })
    }
}
