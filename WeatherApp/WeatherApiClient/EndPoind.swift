//
//  EndPoind.swift
//  WeatherApp
//
//  Created by Ntobeko on 2019/05/18.
//  Copyright © 2019 ntobekosikithi. All rights reserved.
//

import Foundation

enum restaurant {
    case getRestaurants
    case getBookedRestaurant
    case likeRestaurant
    case getRestaurantCount
    case BookRestaurant
    case UpdateBooking
    case CancelBooking
}

extension restaurant: Endpoint {
    
    var base: String {
        return "http://ec2-3-210-163-252.compute-1.amazonaws.com:8092"
    }
    
    var path: String {
        switch self {
        case .getRestaurants: return "/api/v2/restaurant/get_page_sorted/"
        case .getBookedRestaurant: return "/api/v2/booking/get_by_user/"
        case .likeRestaurant: return"/api/v2/like/add/"
        case .getRestaurantCount: return "/api/v2/restaurant/count"
        case .BookRestaurant: return "/api/v2/booking/new/"
        case .UpdateBooking: return "/api/v2/booking/update"
        case .CancelBooking: return "/api/v2/booking/cancel/"
        }
    }
}
