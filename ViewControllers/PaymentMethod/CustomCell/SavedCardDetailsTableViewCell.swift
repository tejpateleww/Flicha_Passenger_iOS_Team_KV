//
//  SavedCardDetailsTableViewCell.swift
//  Flicha User
//
//  Created by Mehul Panchal on 13/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class SavedCardDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var ImgViewIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    @IBOutlet weak var btnSelectedMethod: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.font = UIFont.regular(ofSize: 17)
        self.lblDescriptions.font = UIFont.regular(ofSize: 14)
        self.lblDescriptions.textColor = themeGrayTextColor
        self.btnSelectedMethod.setImage(UIImage.init(named: "square-check-mark"), for: .normal)
        self.btnSelectedMethod.imageView?.contentMode = .scaleAspectFit
        self.ImgViewIcon.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.masksToBounds = true
        self.containerView.dropShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
       
        super.setSelected(selected, animated: animated)
        if selected
        {
            self.containerView.borderColor = UIColor.red
            self.containerView.borderWidth = 1
        }
    }
    
}
