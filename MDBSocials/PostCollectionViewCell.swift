//
//  PostCollectionViewCell.swift
//  FirebaseDemoWeek3
//
//  Created by Sahil Lamba on 2/13/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import UIKit
import Firebase

class PostCollectionViewCell: UICollectionViewCell {
    var post: Post!
    var profileImage: UIImageView!
    var title: UILabel!
    var poster: UILabel!
    var numRSVP: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        setupProfileImage()
        setupTitle()
        setupPoster()
        setupNumRSVP()
    }
    
    func setupProfileImage() {
        profileImage = UIImageView(frame: CGRect(x: 5, y: 5, width: self.frame.width / 2 - 10, height: self.frame.height - 10))
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFit
        contentView.addSubview(profileImage)
    }
    
    func setupTitle() {
        title = UILabel(frame: CGRect(x: profileImage.frame.maxX + 10, y: 10, width: self.frame.width/2 - 10, height: 30))
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightBold)
        title.adjustsFontForContentSizeCategory = true
        contentView.addSubview(title)
    }
    
    func setupPoster() {
        poster = UILabel(frame: CGRect(x: profileImage.frame.maxX + 10, y: title.frame.maxY + 10, width: self.frame.width/2 - 10, height: 0.5 * self.frame.height - 40))
        poster.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
        poster.adjustsFontForContentSizeCategory = true
        contentView.addSubview(poster)
        
    }
    
    func setupNumRSVP() {
        numRSVP = UILabel(frame: CGRect(x: profileImage.frame.maxX + 10, y: poster.frame.maxY + 10, width: self.frame.width/2 - 10, height: 0.5 * self.frame.height - 40))
        numRSVP.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
        numRSVP.adjustsFontForContentSizeCategory = true
        contentView.addSubview(numRSVP)
        
    }

}
