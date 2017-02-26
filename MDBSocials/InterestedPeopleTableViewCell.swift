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
        setupProfileImage()
        userName = UILabel(frame: CGRect(x: 25, y: 0, width: 50, height: 50))
        contentView.addSubview(userName)
    }
    func setupProfileImage() {
        userImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 0.50 * self.frame.height, height: 0.50 * self.frame.height))
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFit
        addSubview(userImage)
    }

    
}

