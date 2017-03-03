//
//  SocialCollectionViewCell.swift
//  MDBSocials
//
//  Created by Amy on 2/21/17.
//  Copyright © 2017 Amy. All rights reserved.
//

import UIKit

class SocialCollectionViewCell: UICollectionViewCell {
    var eventImage: UIImageView!
    var posterText: UILabel!
    var eventNameText: UITextView!
    var interestedButton: UIButton!
    static var num: Int!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        SocialCollectionViewCell.num = 0
        setupEventImage()
        setupPosterText()
        setupPostText()
        setupInterestedButton()
    }
    
    func setupEventImage() {
        
        eventImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 0.50 * self.frame.height + 20, height: 0.8 * self.frame.height + 20))
        eventImage.clipsToBounds = true
        eventImage.contentMode = .scaleAspectFit
        contentView.addSubview(eventImage)
    }
    
    func setupPosterText() {
        
        posterText = UILabel(frame: CGRect(x: eventImage.frame.maxX + 19, y: 45, width: self.frame.width, height: 60))
        posterText.textColor = UIColor.init(red: 0, green: 0.7, blue: 0.7, alpha: 1)
        posterText.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
        posterText.adjustsFontForContentSizeCategory = true
        contentView.addSubview(posterText)
    }
    
    func setupPostText() {
        eventNameText = UITextView(frame: CGRect(x: eventImage.frame.maxX + 18, y: posterText.frame.maxY - 87 , width: self.frame.width, height: 40))
        eventNameText.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        eventNameText.adjustsFontForContentSizeCategory = true
        eventNameText.isEditable = false
        contentView.addSubview(eventNameText)
        
    }
    func setupInterestedButton() {
        interestedButton = UIButton(frame: CGRect(x: eventImage.frame.maxX + 19, y: eventImage.frame.maxY - 39, width: 100, height: 30))
        interestedButton.setTitle((String(SocialCollectionViewCell.num) + " interested"), for: .normal)
        interestedButton.setTitle("Uninterested", for: .selected)
        interestedButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        interestedButton.setTitleColor(UIColor.black, for: .normal)
        contentView.addSubview(interestedButton)
    }
    
}
