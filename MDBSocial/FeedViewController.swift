//
//  FeedViewController.swift
//  MDBSocial
//
//  Created by Levi Walsh on 2/22/17.
//  Copyright © 2017 Levi Walsh. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    var newPostView: UITextField!
    var newPostButton: UIButton!
    var postCollectionView: UICollectionView!
    var posts: [Post] = []
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var storage: FIRStorageReference = FIRStorage.storage().reference()
    var currentUser: User?
    var selectedPost: Post!
    
    //For sample post
    let samplePost = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts.append(samplePost)
        fetchUser {
            self.fetchPosts() {
                print("done")
                self.setupNavBar()
                self.setupButton()
                self.setupCollectionView()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newPost() {
        performSegue(withIdentifier: "FeedToNewPost", sender: self)
    }
    
    func setupNavBar() {
        self.title = "Feed"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Post", style: .plain, target: self, action: #selector(newPost))
    }
    
    func logOut() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            
            navigationController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func setupButton() {
        newPostButton = UIButton(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 50))
        newPostButton.setTitle("Add Post", for: .normal)
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
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "post")
        
        postCollectionView.backgroundColor = UIColor.lightGray
        view.addSubview(postCollectionView)
        
        
    }
    
    func addNewPost(sender: UIButton!) {
        //TODO: Implement using Firebase!
        let postText = newPostView.text!
        self.newPostView.text = ""
        let newPost = ["text": postText, "poster": currentUser?.name, "imageUrl": currentUser?.imageUrl, "numLikes": 0, "posterId": currentUser?.id] as [String : Any]
        let key = postsRef.childByAutoId().key
        let childUpdates = ["/\(key)/": newPost]
        postsRef.updateChildValues(childUpdates)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            self.posts.insert(post, at: 0)
            
            withBlock()
        })
    }
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((self.auth?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            self.currentUser = user
            withBlock()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeedToDetails" {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.post = selectedPost
        }
        else if segue.identifier == "FeedToNewPost" {
            let newPostVC = segue.destination as! NewPostViewController
            newPostVC.user = currentUser
            // newPostVC.post = currentPost
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
        cell.postText.text = postInQuestion.text
        cell.posterText.text = postInQuestion.poster
        
        //TODO(?) Get image from Firebase Storage and put it on the post
        //Uncomment code below to see sample post with profile picture
        cell.profileImage.image = UIImage()
        print(cell.bounds)
        print(UIScreen.main.bounds)
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
        let cell = postCollectionView.cellForItem(at: indexPath) as! PostCollectionViewCell
        selectedPost = cell.post
        performSegue(withIdentifier: "FeedToDetails", sender: self)
    }
    
    
}
