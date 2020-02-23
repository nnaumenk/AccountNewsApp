//
//  Constants.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation

struct CONSTANTS {
    static let NEWS_API_KEY     =   "aa0e9db9c6e7442a86d7b6ccd0144f9c"
    static let WEATHER_API_KEY  =   "791f5e1f4171427666d83dd5d3e7bcf1"
    
    static let NEWS_API_URL     =   "http://newsapi.org/v2/top-headlines?apiKey=\(NEWS_API_KEY)"
    static let SOURCES_API_URL  =   "http://newsapi.org/v2/sources?apiKey=\(NEWS_API_KEY)"
    
    static let WEATHER_API_URL  =   "http://api.weatherstack.com/current?access_key=\(WEATHER_API_KEY)"
}
