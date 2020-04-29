//
//  AvailablesCarsListCollectionViewCell.swift
//  Flicha User
//
//  Created by Mehul Panchal on 25/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class AvailablesCarsListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblCategoryType: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var imageViewCar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.cornerRadius = 10
    }
}
