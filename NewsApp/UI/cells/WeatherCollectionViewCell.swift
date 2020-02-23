//
//  WeatherCollectionViewCell.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var labelMinTemp: UILabel!
    @IBOutlet weak var labelMaxTemp: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var imageCondition: UIImageView!
    
}
