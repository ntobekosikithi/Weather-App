//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Ntobeko on 2019/05/18.
//  Copyright © 2019 ntobekosikithi. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
}

extension Endpoint {
    func requestWithParams(parameters:[URLQueryItem]) ->  URLRequest{
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = parameters
        let request = self.request(components: components)
        return request
    }

    func request(components:URLComponents) -> URLRequest {
        let url = components.url!
        var request = URLRequest(url: url)
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        return request
    }
}
