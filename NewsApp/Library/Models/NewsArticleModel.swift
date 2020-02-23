//
//  ArticleModel.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation

struct NewsArticleModel: Codable {
    var author: String?
    var title: String?
    var description: String?
    var urlToImage: String?
    var publishedAt: String?
}
