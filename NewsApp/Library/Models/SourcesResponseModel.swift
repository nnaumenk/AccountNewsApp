//
//  SourcesResponse.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation

struct SourcesResponseModel: Codable {
    var status: String
    var sources: [UserDataSourceModel]
}
