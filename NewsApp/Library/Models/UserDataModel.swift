//
//  UserData.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation

struct UserDataModel: Codable {
    var firstName: String
    var lastName: String
    var mobileNumber: String
    var birhday: String
    var country: String
    var countryENG: String
    var city: String
    var cityENG: String
    var sources: [UserDataSourceModel]
}


