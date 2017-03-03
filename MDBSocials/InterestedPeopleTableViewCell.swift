//
//  InterestedPeopleTableViewCell.swift
//  MDBSocials
//
//  Created by Amy on 2/25/17.
//  Copyright © 2017 Amy. All rights reserved.
//

import UIKit

class InterestedPeopleTableViewCell: UITableViewCell {
    

    var userImage: UIImageView!
    var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userName = UILabel(frame: CGRect(x: 45, y: 0, width: 50, height: 50))
        userImage = UIImageView(frame: CGRect(x: 5, y: 2, width: 50, height: 50))

        contentView.addSubview(userImage)
        contentView.addSubview(userName)
    }
   

    
}

