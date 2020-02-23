//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    private init() {}
    static let shared = NetworkManager()
    
    func sendGETRequestResponseData(stringURL: String, completionHandler: @escaping (Data?) -> Void) {
        
        guard let url = URL(string: stringURL) else {
            completionHandler(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            
            print("\n\nerror", error)
            print("\n\nresponse", response)
            if let data = data {
                print("\n\ndata", try? JSONSerialization.jsonObject(with: data, options: []))
            }
            
            
            DispatchQueue.main.async {
                completionHandler(data)
            }
            
        }).resume()
    }
    
    func sendGETRequestResponseModel<T: Codable>(stringURL: String, completionHandler: @escaping (T?) -> Void) {
        
        sendGETRequestResponseData(stringURL: stringURL, completionHandler: { data in
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            
            guard let responseModel: T = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(nil)
                return
            }
            
            completionHandler(responseModel)
        })
    }

}


