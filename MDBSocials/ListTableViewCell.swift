//
//  ListTableViewCell.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/25/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.zero // make cell border extend to lefts
        name = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        name.font = UIFont.boldSystemFont(ofSize: 15)
        contentView.addSubview(name)
    }
}
