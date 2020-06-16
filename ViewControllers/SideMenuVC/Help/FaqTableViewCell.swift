//
//  FaqTableViewCell.swift
//  Flicha User
//
//  Created by EWW074 on 16/06/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class FaqTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lbl_Question: UILabel!
    @IBOutlet weak var lbl_Answer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
