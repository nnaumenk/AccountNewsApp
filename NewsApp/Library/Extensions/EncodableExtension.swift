//
//  Encodable.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation

extension Encodable {
    
    var dictionary: [String : Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
        
        return dict as? [String: Any]
    }
}
