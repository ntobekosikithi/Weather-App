//
//  forecastTableViewCell.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/16.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import UIKit

class forecastTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDegrees: UILabel!
    @IBOutlet weak var forecastIcon: UIImageView!
    @IBOutlet weak var lblDay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
