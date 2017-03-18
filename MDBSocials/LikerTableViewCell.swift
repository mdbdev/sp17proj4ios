//
//  LikerTableViewCell.swift
//  MDBSocials
//
//  Created by Zach Govani on 3/2/17.
//  Copyright © 2017 Zach Govani. All rights reserved.
//

import UIKit

class LikerTableViewCell: UITableViewCell {
    var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupName()
        // Initialization code
    }
    func setupName() {
    name = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width - 10, height: self.frame.height - 10))
    name.textColor = UIColor.black
    name.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightBold)
    name.adjustsFontForContentSizeCategory = true
    contentView.addSubview(name)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
