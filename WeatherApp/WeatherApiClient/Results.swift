//
//  Results.swift
//  WeatherApp
//
//  Created by Ntobeko on 2019/05/18.
//  Copyright © 2019 ntobekosikithi. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
