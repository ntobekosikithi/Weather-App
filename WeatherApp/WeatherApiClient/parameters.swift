//
//  parameters.swift
//  WeatherApp
//
//  Created by Ntobeko on 2019/05/18.
//  Copyright © 2019 ntobekosikithi. All rights reserved.
//

import Foundation
class parameters{
    class func setParametes(lat:String, lon:String) -> [URLQueryItem]? {
        let parameters = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "appid", value: constants.api_key),
            URLQueryItem(name: "units", value: constants.units)
        ]
        return parameters
    }
}
