//
//  weather.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/16.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import Foundation
struct weather : Codable{
    let weather: [description]
    let main: temperature
    let date: String?
}

extension weather {
    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case date = "dt_txt"
    }
}
