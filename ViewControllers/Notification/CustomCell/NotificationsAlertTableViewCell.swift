//
//  NotificationsAlertTableViewCell.swift
//  Flicha User
//
//  Created by Mehul Panchal on 15/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class NotificationsAlertTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font = UIFont.semiBold(ofSize: 15)
        self.lblDescriptions.font = UIFont.regular(ofSize: 12)
    }
    
    override func layoutSubviews() {
        super.layoutIfNeeded()
        self.imageViewContainer.backgroundColor = themeGrayBGColor
        self.imageViewContainer.layer.cornerRadius = self.imageViewContainer.frame.size.width / 2
        self.imageViewContainer.layer.masksToBounds = true
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
