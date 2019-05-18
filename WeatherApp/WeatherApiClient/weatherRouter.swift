//  weatherRouter.swift
//  WeatherApp
//
//  Created by Ntobeko on 2019/05/18.
//  Copyright © 2019 ntobekosikithi. All rights reserved.
//

import Foundation

enum weatherRouter {
    case getCurrentWeather
    case getForecast
}

extension weatherRouter: Endpoint {
    var base: String {
        return constants.baseURL
    }
    
    var path: String {
        switch self {
        case .getCurrentWeather: return "/data/2.5/weather"
        case .getForecast: return "/data/2.5/forecast"
        }
    }
}
