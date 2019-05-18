//
//  Constants.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/15.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//


import Foundation

struct constants {
    static let baseURL = "https://api.openweathermap.org"
    static let api_key = "615c0b5cdb6822c4fcec3e0c800469c7"
    static let units = "metric"
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
}
