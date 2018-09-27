//
//  temperature.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/16.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import Foundation
struct temperature : Codable{
    let current: Double
    let min: Double
    let max: Double
}
extension temperature {
    enum CodingKeys: String, CodingKey {
        case current = "temp"
        case min = "temp_min"
        case max = "temp_max"
    }
}
