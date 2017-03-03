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
    var profileImage: UIImageView!
    var posterText: UILabel!
    var postText: UITextView!
    var postDate: UILabel!
    var postTitle: UILabel!
    var likeButton: UIButton!
    var whoButton: UIButton!
    var tallyText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImage()
        setupPostTitle()
        setupPostDate()
        setupPosterText()
        setupPostText()
        setupLikeButton()
        setupWhoButton()
        setupTallyText()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfileImage() {
        profileImage = UIImageView(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40))
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFit
        profileImage.loadGif(name: "loading-1")
        view.addSubview(profileImage)
        post.getProfilePic(withBlock: { profImage in
            DispatchQueue.main.async {
                self.profileImage.image = profImage
                
            }
        })
    }
    
    func setupPostTitle() {
        postTitle = UILabel(frame: CGRect(x: 10, y: profileImage.frame.maxY + 10, width: view.frame.width/2, height: 30))
        postTitle.textColor = UIColor.black
        postTitle.font = UIFont.systemFont(ofSize: 24, weight: 2)
        postTitle.adjustsFontForContentSizeCategory = true
        postTitle.text = post.title
        view.addSubview(postTitle)
    }
    
    func setupPostDate() {
        postDate = UILabel(frame: CGRect(x: 10, y: postTitle.frame.maxY + 10, width: view.frame.width/2, height: 30))
        postDate.textColor = UIColor.black
        postDate.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightRegular)
        postDate.adjustsFontForContentSizeCategory = true
        postDate.text = post.date
        print(post.date!)
        view.addSubview(postDate)
    }
    
    func setupPosterText() {
        posterText = UILabel(frame: CGRect(x: 10, y: postDate.frame.maxY + 10, width: view.frame.width/2, height: 30))
        posterText.textColor = UIColor.black
        posterText.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        posterText.adjustsFontForContentSizeCategory = true
        posterText.text = post.poster
        view.addSubview(posterText)
    }
    
    func setupPostText() {
        postText = UITextView(frame: CGRect(x: 10, y: posterText.frame.maxY + 10, width: view.frame.width, height: 50))
        postText.textColor = UIColor.black
        posterText.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightThin)
        postText.isEditable = false
        postText.text = post.description
        view.addSubview(postText)
        
    }
    func setupLikeButton() {
        likeButton = UIButton(frame: CGRect(x: 10, y: postText.frame.maxY + 10, width: view.frame.width/2 - 10, height: 30))
        likeButton.setTitle("RSVP", for: .normal)
        likeButton.setTitleColor(UIColor.blue, for: .normal)
        if post.likers.contains(user.id) {
            likeButton.setTitleColor(UIColor.green, for: .normal)
        }
        likeButton.addTarget(self, action: #selector(DetailViewController.likeButtonPressed), for: .touchUpInside)
        view.addSubview(likeButton)
    }
    func setupWhoButton() {
        whoButton = UIButton(frame: CGRect(x: likeButton.frame.maxX, y: postText.frame.maxY + 10, width: view.frame.width/2 - 10, height: 30))
        whoButton.setTitle("Who is going?", for: .normal)
        whoButton.setTitleColor(UIColor.blue, for: .normal)
        whoButton.addTarget(self, action: #selector(DetailViewController.whoButtonPressed), for: .touchUpInside)
        view.addSubview(whoButton)
    }
    
    func setupTallyText() {
        tallyText = UILabel(frame: CGRect(x: 10, y: likeButton.frame.maxY + 10, width: view.frame.width/2 - 10, height: 30))
        tallyText.text = "There are " + String(self.post.likers.count) +  " people RSVP'd."
        tallyText.font = UIFont.systemFont(ofSize: 24, weight: 2)
        tallyText.adjustsFontForContentSizeCategory = true
        tallyText.adjustsFontSizeToFitWidth = true
        view.addSubview(tallyText)
    }
    
    func likeButtonPressed() {
        if post.go == Post.goingStatus.notGoing {
            post.addInterestedUser(withId: user.id)
            likeButton.setTitleColor(UIColor.green, for: .normal)
            tallyText.text = "There are " + String(self.post.likers.count) +  " people RSVP'd."
        }
        
    }
    func whoButtonPressed() {
        performSegue(withIdentifier: "toLikersFromDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLikersFromDetail" {
            let likerVC = segue.destination as! LikersViewController
            likerVC.post = post
        }
    }
    
}


