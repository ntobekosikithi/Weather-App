//
//  WeatherAPIClient.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/15.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import Alamofire

class WeatherAPIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        return Alamofire.request(route)
            .responseJSONDecodable (decoder: decoder){ (response: DataResponse<T>) in
                completion(response.result)
        }
    }
    
    static func currentWeather(latitude: String, longitude: String, completion:@escaping (Result<weather>)->Void) {
        performRequest(route: APIRouter.currentWeather(lat: latitude, lon: longitude),completion: completion)
    }
    
    static func forecast(latitude: String, longitude: String, completion:@escaping (Result<forecast>)->Void) {
        performRequest(route: APIRouter.forecast(lat: latitude, lon: longitude), completion: completion)
    }
}
