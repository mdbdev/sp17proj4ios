//
//  DetailViewController.swift
//  MDBSocials
//
//  Created by Zach Govani on 2/25/17.
//  Copyright © 2017 Zach Govani. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    var post: Post!
    var user: User!
    var ref: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var profileImage: UIImageView!
    var posterText: UILabel!
    var postText: UITextView!
    var likeButton: UIButton!
    var tallyText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImage()
        setupPosterText()
        setupPostText()
        setupLikeButton()
        setupTallyText()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfileImage() {
        profileImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 0.50 * view.frame.width, height: 0.50 * view.frame.height))
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFit
        view.addSubview(profileImage)
    }
    
    func setupPosterText() {
        posterText = UILabel(frame: CGRect(x: 10, y: profileImage.frame.maxY + 10, width: view.frame.width/2, height: 30))
        posterText.textColor = UIColor.black
        posterText.font = UIFont.systemFont(ofSize: 24, weight: 2)
        posterText.adjustsFontForContentSizeCategory = true
        posterText.text = post.description
        view.addSubview(posterText)
    }
    
    func setupPostText() {
        postText = UITextView(frame: CGRect(x: 10, y: posterText.frame.maxY + 10, width: view.frame.width, height: 30))
        postText.textColor = UIColor.black
        postText.adjustsFontForContentSizeCategory = true
        postText.isEditable = false
        postText.text = post.description
        view.addSubview(postText)
        
    }
    func setupLikeButton() {
        likeButton = UIButton(frame: CGRect(x: 10, y: postText.frame.maxY + 10, width: view.frame.width/2, height: 30))
        likeButton.setTitle("RSVP", for: .normal)
        likeButton.setTitleColor(UIColor.blue, for: .normal)
        likeButton.addTarget(self, action: #selector(DetailViewController.buttonPressed), for: .touchUpInside)
        view.addSubview(likeButton)
    }
    
    func setupTallyText() {
        tallyText = UILabel(frame: CGRect(x: 10, y: likeButton.frame.maxY + 10, width: view.frame.width/2 - 10, height: 30))
        tallyText.text = "There are " + String(self.post.likers.count) +  " people RSVP'd."
        tallyText.font = UIFont.systemFont(ofSize: 24, weight: 2)
        tallyText.adjustsFontForContentSizeCategory = true
        tallyText.adjustsFontSizeToFitWidth = true
        view.addSubview(tallyText)
    }
    
    func buttonPressed() {
        if !self.post.likers.contains(user.id!) {
            self.post.likers.append(user.id!)
        }
        let childUpdates = ["\(self.post.id!)/likers": self.post.likers!]
        ref.updateChildValues(childUpdates)
        tallyText.text = "There are " + String(self.post.likers.count) +  " people RSVP'd."
    }
    
}


