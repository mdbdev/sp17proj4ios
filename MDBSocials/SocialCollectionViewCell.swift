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
    var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        setupEventImage()
        setupPosterText()
        setupPostText()
        setupLikeButton()
    }
    
    func setupEventImage() {
        eventImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 0.50 * self.frame.height, height: 0.50 * self.frame.height))
        eventImage.clipsToBounds = true
        eventImage.contentMode = .scaleAspectFit
        addSubview(eventImage)
    }
    
    func setupPosterText() {
        posterText = UILabel(frame: CGRect(x: eventImage.frame.maxX + 10, y: 10, width: self.frame.width, height: 30))
        posterText.textColor = UIColor.black
        posterText.font = UIFont.systemFont(ofSize: 24, weight: 2)
        posterText.adjustsFontForContentSizeCategory = true
        addSubview(posterText)
    }
    
    func setupPostText() {
        eventNameText = UITextView(frame: CGRect(x: eventImage.frame.maxX + 10, y: posterText.frame.maxY + 10, width: self.frame.width, height: 0.5 * self.frame.height - 40))
        eventNameText.textColor = UIColor.black
        eventNameText.adjustsFontForContentSizeCategory = true
        eventNameText.isEditable = false
        addSubview(eventNameText)
        
    }
    func setupLikeButton() {
        likeButton = UIButton(frame: CGRect(x: 50, y: eventImage.frame.maxY + 10, width: 200, height: 30))
        likeButton.setTitle("Interested", for: .normal)
        likeButton.setTitle("Uninterested", for: .selected)
        likeButton.setTitleColor(UIColor.blue, for: .normal)
        addSubview(likeButton)
    }
    
}
