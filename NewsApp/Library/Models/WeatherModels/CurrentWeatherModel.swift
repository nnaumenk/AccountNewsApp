//
//  CurrentWeatherModel.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation

struct CurrentWeatherModel: Codable {
    var condition: ConditionWeatherModel
    var temp_c: Double
    var wind_kph: Double
    var wind_dir: String
    var pressure_mb: Double
    var humidity: Int
}
