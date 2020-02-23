//
//  ForecastModel.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation

struct ForecastWeatherModel: Codable {
    var forecastday: [ForecastDayWeatherModel]
}

struct ForecastDayWeatherModel: Codable {
    var day: DayWeatherModel
    var date: String
}

struct DayWeatherModel: Codable {
    var maxtemp_c: Double
    var mintemp_c: Double
    var condition: ConditionWeatherModel
}



