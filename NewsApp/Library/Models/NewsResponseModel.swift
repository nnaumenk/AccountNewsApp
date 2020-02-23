//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation

struct NewsResponseModel: Codable {
    var status: String
    var totalResults: Int
    var articles: [NewsArticleModel]
}
