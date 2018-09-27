//
//  APIRouter.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/15.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case currentWeather(lat:String, lon:String)
    case forecast(lat:String, lon:String)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .currentWeather:
            return .get
        case .forecast:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .currentWeather:
            return "weather?"
        case .forecast:
            return "forecast?"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Array<String> {
        switch self {
        case .currentWeather(let lat, let lon):
            return [lat,lon]
        case .forecast(let lat, let lon):
            return [lat,lon]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = constants.baseURL + path
        var urlstring = URLComponents(string: url)!

        // Parameters
        urlstring.queryItems = [
            URLQueryItem(name:"lat", value:parameters[0]),
            URLQueryItem(name:"lon", value:parameters[1]),
            URLQueryItem(name:"appid", value:constants.api_key),
            URLQueryItem(name:"units", value:constants.units)
        ]
        var urlRequest = URLRequest(url: urlstring.url!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        print(urlRequest)
        return urlRequest
    }
}
