//
//  DetailsViewController.swift
//  MDBSocial
//
//  Created by Levi Walsh on 2/25/17.
//  Copyright © 2017 Levi Walsh. All rights reserved.
//

import UIKit
import Firebase

class DetailsViewController: UIViewController {
    
    var post: Post!
    var user: User!
    var ref: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var profileImageView: UIImageView!
    var posterName: UILabel!
    var postText: UILabel!
    var likeButton: UIButton!
    var tallyText: UILabel!
    var postTitle: UILabel!
    var postDate: UILabel!
    var guestButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImage()
        setupPosterName()
        setupPostTitle()
        setupPostDate()
        setupPostText()
        setupLikeButton()
        setupGuestButton()
        setupTallyText()
        // Do any additional setup after loading the view.
    }
    
    func setupProfileImage() {
        profileImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20))
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFit
        view.addSubview(profileImageView)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        post.getImage(withBlock: { profileImage in
            DispatchQueue.main.async {
                self.profileImageView.image = (profileImage)
            }
        })
    }
    
    func setupPosterName() {
        posterName = UILabel(frame: CGRect(x: 10, y: profileImageView.frame.maxY + 10, width: view.frame.width/2, height: 30))
        posterName.textColor = UIColor.black
        posterName.font = UIFont.systemFont(ofSize: 24, weight: 2)
        posterName.adjustsFontForContentSizeCategory = true
        posterName.text = post.poster
        view.addSubview(posterName)
    }
    
    func setupPostTitle() {
        postTitle = UILabel(frame: CGRect(x: 10, y: posterName.frame.maxY + 10, width: view.frame.width/2, height: 30))
        postTitle.textColor = UIColor.black
        postTitle.font = UIFont.systemFont(ofSize: 24, weight: 2)
        postTitle.adjustsFontForContentSizeCategory = true
        postTitle.text = post.title
        view.addSubview(postTitle)
    }
    
    func setupPostDate() {
        postDate = UILabel(frame: CGRect(x: 10, y: postTitle.frame.maxY + 10, width: view.frame.width/2, height: 30))
        postDate.textColor = UIColor.black
        postDate.font = UIFont.systemFont(ofSize: 24, weight: 2)
        postDate.adjustsFontForContentSizeCategory = true
        postDate.text = post.date
        view.addSubview(postDate)
    }
    
    func setupPostText() {
        postText = UILabel(frame: CGRect(x: 10, y: postDate.frame.maxY + 10, width: view.frame.width / 2, height: 30))
        postText.textColor = UIColor.black
        postDate.font = UIFont.systemFont(ofSize: 12, weight: 2)
        postText.adjustsFontForContentSizeCategory = true
        print("Making it to the description block")
        // post.postText is not getting the right text, but it isn't recognizing post.description which is what is in my database I think
        postText.text = post.postText
        view.addSubview(postText)
    }
    
    func setupLikeButton() {
        likeButton = UIButton(frame: CGRect(x: 10, y: postText.frame.maxY + 10, width: view.frame.width/3, height: 30))
        likeButton.setTitle("Interested", for: .normal)
        likeButton.setTitleColor(UIColor.blue, for: .normal)
        likeButton.addTarget(self, action: #selector(DetailsViewController.interestedButtonPressed), for: .touchUpInside)
        view.addSubview(likeButton)
    }
    
    func setupGuestButton() {
        guestButton = UIButton(frame: CGRect(x: likeButton.frame.maxX + 10, y: postText.frame.maxY + 10, width: view.frame.width / 3, height: 30))
        guestButton.setTitle("Guest List", for: .normal)
        guestButton.setTitleColor(UIColor.darkGray, for: .normal)
        guestButton.addTarget(self, action: #selector(DetailsViewController.guestButtonPressed), for: .touchUpInside)
        view.addSubview(guestButton)
    }
    
    func guestButtonPressed() {
        performSegue(withIdentifier: "DetailsToComing", sender: self)
    }
    
    func setupTallyText() {
        tallyText = UILabel(frame: CGRect(x: 10, y: likeButton.frame.maxY + 10, width: view.frame.width/2 - 10, height: 30))
        tallyText.text = String(self.post.guests.count) +  " coming."
        tallyText.font = UIFont.systemFont(ofSize: 24, weight: 2)
        tallyText.adjustsFontForContentSizeCategory = true
        tallyText.adjustsFontSizeToFitWidth = true
        view.addSubview(tallyText)
    }
    
    func interestedButtonPressed() {
        if post.go == Post.goingStatus.notGoing {
            post.addInterestedUser(withId: user.id!)
            tallyText.text = String(self.post.guests.count) +  " coming."
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
