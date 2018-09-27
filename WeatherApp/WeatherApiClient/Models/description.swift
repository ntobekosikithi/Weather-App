//
//  description.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/16.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import Foundation
struct description : Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}
extension description {
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
}
