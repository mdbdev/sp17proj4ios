//
//  FeedViewController.swift
//  FirebaseDemo
//
//  Created by Sahil Lamba on 2/12/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import UIKit
import Firebase
import SwiftGifOrigin

class FeedViewController: UIViewController {
    
    var postCollectionView: UICollectionView!
    var posts: [Post] = []
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var storage: FIRStorageReference = FIRStorage.storage().reference()
    var currentUser: User?
    var clickedPost: Post!
    
    //For sample post
    let samplePost = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Do I reach here")
        fetchUser {
            self.fetchPosts() {
                self.setupNavBar()
                self.setupCollectionView()
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        self.title = "Feed"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Post", style: .plain, target: self, action: #selector(newPost))
        
    }
    
    func logOut() {
        //TODO: Log out using Firebase!
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func newPost() {
        self.performSegue(withIdentifier: "toNewFromFeed", sender: self)
    }
    
    func setupCollectionView() {
        let frame = CGRect(x: 10, y: (navigationController?.navigationBar.frame.maxY)!, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 20)
        let cvLayout = UICollectionViewFlowLayout()
        postCollectionView = UICollectionView(frame: frame, collectionViewLayout: cvLayout)
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "post")
        postCollectionView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 50/2, right: 0)

        postCollectionView.backgroundColor = UIColor.lightGray
//        postCollectionView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 50/2, right: 0)
        view.addSubview(postCollectionView)
        
        
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            DispatchQueue.main.async {
            let post = Post(id: snapshot.key, postDict: (snapshot.value as! [String : Any]?)!)
            if post.likers.contains((self.currentUser?.id)!) {
                post.go = Post.goingStatus.going
            }
            self.posts.insert(post, at: 0)
            withBlock()
            }
        })
    }
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((self.auth?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            DispatchQueue.main.async {
                print("Fetching user...")
                let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
                self.currentUser = user
                print("The user's email is \(self.currentUser?.email)")
                withBlock()
            }
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailFromFeed" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.post = clickedPost
            detailVC.user = currentUser
        } else if segue.identifier == "toNewFromFeed" {
            let newVC = segue.destination as! NewSocialViewController
            newVC.currentUser = currentUser
        }
    }
    
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
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostCollectionViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        let postInQuestion = posts[indexPath.row]
        cell.profileImage.loadGif(name: "loading-1")
        postInQuestion.getProfilePic(withBlock: { profImage in
            DispatchQueue.main.async {
                cell.profileImage.image = profImage

            }
        })
        
        cell.poster.text = postInQuestion.poster
        cell.numRSVP.text = "RSVP Number: " + String(postInQuestion.likers.count)
        cell.title.text = postInQuestion.title
        cell.post = postInQuestion
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
        let cell =  postCollectionView.cellForItem(at: indexPath) as! PostCollectionViewCell
        clickedPost = cell.post
        performSegue(withIdentifier: "toDetailFromFeed", sender: self)
    }
    
    
}
