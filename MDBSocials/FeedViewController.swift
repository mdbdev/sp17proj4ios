//
//  FeedViewController.swift
//  FirebaseDemo
//
//  Created by Sahil Lamba on 2/12/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import UIKit
import Firebase

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
//        postCollectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 50/2, right: 0)

        postCollectionView.backgroundColor = UIColor.lightGray
        view.addSubview(postCollectionView)
        
        
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: (snapshot.value as! [String : Any]?)!)
            self.posts.append(post)
            
            withBlock()
        })
    }
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((self.auth?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            print("Fetching user...")
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            self.currentUser = user
            print("The user's email is \(self.currentUser?.email)")
            withBlock()
            
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
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostCollectionViewCell
        cell.awakeFromNib()
        let postInQuestion = posts[indexPath.row]
        cell.postText.text = postInQuestion.description
        cell.posterText.text = postInQuestion.poster
        cell.post = postInQuestion
        
        //TODO(?) Get image from Firebase Storage and put it on the post
        //Uncomment code below to see sample post with profile picture
        cell.profileImage.image = UIImage(named: "yeezy")
        print(cell.bounds)
//        print(UIScreen.main.bounds)
//        cell.likeButton.tag = indexPath.row
//        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
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
