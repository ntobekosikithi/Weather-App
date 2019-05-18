//
//  WeatherAPIClient.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/15.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import Foundation
class WeatherAPIClient: APIClient {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }

    func current(weatherData: weatherRouter, lat:String, lon:String, completion: @escaping (Result<weather?, APIError>) -> Void) {
        let endpoint = weatherData
        let params = parameters.setParametes(lat: lat, lon: lon)
        let request = endpoint.requestWithParams(parameters: params!)

        fetch(with: request, decode: { json -> weather? in
            guard let weatherResult = json as? weather else { return  nil }
            return weatherResult
        }, completion: completion)
    }

    func forecast(weatherData: weatherRouter, lat:String, lon:String, completion: @escaping (Result<forecast?, APIError>) -> Void) {
        let endpoint = weatherData
        let params = parameters.setParametes(lat: lat, lon: lon)
        let request = endpoint.requestWithParams(parameters: params!)

        fetch(with: request, decode: { json -> forecast? in
            guard let forecastResult = json as? forecast else { return  nil }
            return forecastResult
        }, completion: completion)
    }
}
