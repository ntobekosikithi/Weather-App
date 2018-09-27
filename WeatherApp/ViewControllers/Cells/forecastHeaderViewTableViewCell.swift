//
//  forecastHeaderViewTableViewCell.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/16.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import UIKit

class forecastHeaderViewTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
