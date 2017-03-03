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
    var newPostButton: UIBarButtonItem!
    var collectionView: UICollectionView!
    var interestedUsers: [String] = []
    static var posts: [Social] = []
    var postIds: [String] = []
    var auth = FIRAuth.auth()
    var users: [User] = []
    var indexPath: Int = 0
    var logOutButton: UIBarButtonItem!
    static var currentUser: User!
    var refToUsers = FIRDatabase.database().reference().child("Users")

    //For sample post
    
    var selectedEvent: Social!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        fetchPosts {
            self.fetchUser {
            }
            self.setupNavBar()
            self.setupCollectionView()
               
            }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupBackground() {
        
        //sets up gradient background
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "turquoiseBackground")?.draw(in: self.view.bounds)
        
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        } else {
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            DetailViewController.postIds = postIds
            DetailViewController.currentEvent = selectedEvent
            DetailViewController.indexPath = indexPath
        }
    }
    func setupNavBar() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0, green: 0.91, blue: 0.91, alpha: 1)
        
        //set up feed title
        self.title = "Feed"
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white,  NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 25)!];
        
        //set up logout button
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "logout.jpg"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(logOut), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 33, height: 26)
        logOutButton = UIBarButtonItem(customView: button)
        
        //set up newPost button
        let button2: UIButton = UIButton(type: UIButtonType.custom)
        button2.setImage(UIImage(named: "newPost.jpg"), for: UIControlState.normal)
        button2.addTarget(self, action: #selector(addNewPost), for: UIControlEvents.touchUpInside)
        button2.frame = CGRect(x: 0, y: 0, width: 25, height: 23)
        newPostButton = UIBarButtonItem(customView: button2)
        
        //assign buttons to navigationbar
        self.navigationItem.leftBarButtonItem = logOutButton
        self.navigationItem.rightBarButtonItem = newPostButton
    }
    
    func setupCollectionView() {
        let frame = CGRect(x: 0, y: 63, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 80)
      
        let cvLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: cvLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SocialCollectionViewCell.self, forCellWithReuseIdentifier: "post2")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        
        
    }
    func fetchPosts(withBlock: @escaping () -> ()) {
        //GET actual key not snapshot key
        //appends each initialized post (w/ key and postDict) into posts array to be displayed
        let ref = FIRDatabase.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Social(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            FeedViewController.posts.append(post)
            self.postIds.append(snapshot.key)
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
            self.performSegue(withIdentifier: "logOut", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    func addNewPost(sender: UIButton!) {
        performSegue(withIdentifier: "toNewSocial", sender: nil)
      
    }
    
}

protocol LikeButtonProtocol {
    func likeButtonClicked(sender: UIButton!)
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return FeedViewController.posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post2", for: indexPath) as! SocialCollectionViewCell

        for subview in cell.contentView.subviews {
            subview.removeFromSuperview() //remove stuff from cell before initializing
        }
        
        cell.awakeFromNib()
        let postInQuestion = FeedViewController.posts[indexPath.item]
        cell.eventNameText.text = postInQuestion.eventName
        cell.posterText.text = "@" + postInQuestion.poster!
        cell.interestedButton.setTitle(String(postInQuestion.interestedNumber)+" interested", for: .normal)
        DetailViewController.indexPath = self.indexPath
        postInQuestion.getEventPic {
            
            let imageData = UIImageJPEGRepresentation(postInQuestion.image!, 0.09)
            cell.eventImage.image = UIImage(data: imageData!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedEvent = FeedViewController.posts[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    
}


