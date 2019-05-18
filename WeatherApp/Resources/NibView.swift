//
//  NibView.swift
//  WeatherApp
//
//  Created by Ntobeko on 2019/05/18.
//  Copyright © 2019 ntobekosikithi. All rights reserved.
//

import UIKit

protocol NibView: class {}

extension NibView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
