//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Amy on 2/21/17.
//  Copyright © 2017 Amy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class FeedViewController: UIViewController {
    
    var newPostView: UITextField!
    var newPostButton: UIButton!
    var postCollectionView: UICollectionView!
    var posts: [Social] = []
    var auth = FIRAuth.auth()
    var users: [User] = []
    static var currentUser: User!
    //For sample post
    
    var selectedEvent: Social!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
      
        fetchUser {
            self.fetchPosts() {
                print("done")
                self.setupNavBar()
               
                self.setupButton()
                
                self.setupCollectionView()
                
                
                
                activityIndicator.stopAnimating()
            }
        }    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            
            DetailViewController.currentEvent = selectedEvent
        }
    }
    func setupNavBar() {
        self.title = "Feed"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
    }
    

 
    
    func setupButton() {
        newPostButton = UIButton(frame: CGRect(x: 10, y: 60, width: UIScreen.main.bounds.width - 20, height: 50))
        newPostButton.setTitle("New Social", for: .normal)
        newPostButton.setTitleColor(UIColor.blue, for: .normal)
        newPostButton.layoutIfNeeded()
        newPostButton.layer.borderWidth = 2.0
        newPostButton.layer.cornerRadius = 3.0
        newPostButton.layer.borderColor = UIColor.blue.cgColor
        newPostButton.layer.masksToBounds = true
        newPostButton.addTarget(self, action: #selector(addNewPost), for: .touchUpInside)
        view.addSubview(newPostButton)
    }
    
    
    func setupCollectionView() {
        let frame = CGRect(x: 10, y: newPostButton.frame.maxY + 10, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - newPostButton.frame.maxY - 20)
        let cvLayout = UICollectionViewFlowLayout()
        postCollectionView = UICollectionView(frame: frame, collectionViewLayout: cvLayout)
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(SocialCollectionViewCell.self, forCellWithReuseIdentifier: "post")
        
        postCollectionView.backgroundColor = UIColor.lightGray
        view.addSubview(postCollectionView)
        
        
    }
    func fetchPosts(withBlock: @escaping () -> ()) {
        //appends each initialized post (w/ key and postDict) into posts array to be displayed
        let ref = FIRDatabase.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Social(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            self.posts.append(post)
            
            withBlock()
        })
    }

    
    

    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((self.auth?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            FeedViewController.currentUser = user
            withBlock()
            
        })
    }
    func logOut() {
        //TODO: Log out using Firebase!
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            self.performSegue(withIdentifier: "logout", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    func addNewPost(sender: UIButton!) {
        performSegue(withIdentifier: "toNewSocial", sender: nil)
      
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

protocol LikeButtonProtocol {
    func likeButtonClicked(sender: UIButton!)
}

extension FeedViewController: LikeButtonProtocol {
    func likeButtonClicked(sender: UIButton!) {
        //TODO: Implement like button using Firebase transactions!
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! SocialCollectionViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview() //remove stuff from cell before initializing
        }
       
        cell.awakeFromNib()
        let postInQuestion = posts[indexPath.row]
        cell.eventNameText.text = postInQuestion.eventName
        cell.posterText.text = postInQuestion.poster
        
        if indexPath.row == 0 || indexPath.row == 1{
            cell.eventImage.image = UIImage(named: "yeezy")
        }
        else {
            postInQuestion.getEventPic {
                cell.eventImage.image = postInQuestion.image
            }
        }
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return cell
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: postCollectionView.bounds.width - 20, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedEvent = posts[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    
}
