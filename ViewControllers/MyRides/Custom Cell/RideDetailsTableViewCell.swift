//
//  RideDetailsTableViewCell.swift
//  Flicha User
//
//  Created by Mehul Panchal on 18/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class RideDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imageViewRideRoute: UIImageView!
    @IBOutlet weak var lblCategoryType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var lblPriceValue: UILabel!
    @IBOutlet weak var PriceStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    private func setupView(){
        
        containerView.cornerRadius = 5
        containerView.dropShadow()
        
        lblTime.text = ""
        lblTime.font = UIFont.regular(ofSize: 12)
        lblTime.textColor = themeBlackColor
        
        lblCategoryType.text = ""
        lblCategoryType.font = UIFont.regular(ofSize: 12)
        lblCategoryType.textColor = themeBlackColor
        
        lblPriceTitle.text = kPriceTitle
        lblPriceTitle.font = UIFont.regular(ofSize: 10)
        lblPriceTitle.textColor = themeGrayTextColor
        
        lblPriceValue.text = ""
        lblPriceValue.font = UIFont.regular(ofSize: 12)
        lblPriceValue.textColor = themeYellowColor
        
        lblAddress.text = ""
        lblAddress.font = UIFont.regular(ofSize: 10)
        lblAddress.textColor = themeBlackColor
        
        imageViewRideRoute.contentMode = .scaleToFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
