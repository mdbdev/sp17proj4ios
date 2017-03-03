//
//  DetailViewController.swift
//  The Social Network
//
//  Created by Mark Siano on 2/25/17.
//  Copyright © 2017 Mark Siano. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DetailViewController: UIViewController {
    
    var post: Post!
    var currentUser: User!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var poster: UILabel!
    var date: UILabel!
    var descriptionText: UITextView!
    var descriptionTitle: UILabel!
    var numInterestedButton: UIButton!
    var interestedButton: UIButton!
    var indexPath: IndexPath!
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var backButton: UIButton!
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            self.currentUser = user
            withBlock()
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser {
            self.initImageView()
            self.initTitleText()
            self.initPoster()
            self.initDescription()
            self.initNumInterested()
            self.initInterested()
            self.initBackButton()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func initBackButton() {
        backButton = UIButton(frame: CGRect(x: 0, y: interestedButton.frame.minY - 40, width: view.frame.width, height: 40))
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 230/255, alpha: 1.0)
        backButton.setTitleColor(UIColor.white, for: .normal)
        
        backButton.addTarget(self, action: #selector(backPressed), for: UIControlEvents.touchUpInside)
        
        view.addSubview(backButton)
    }
    
    func backPressed() {
        _ = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func initImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: mainInstance.imageWidth, height: mainInstance.imageHeight))
        print(post.imageUrl)
        imageView.layer.masksToBounds = true
        
        let storage = FIRStorage.storage()
        storage.reference(forURL: post.imageUrl!).data(withMaxSize: 2048 * 2048 * 2048, completion: { (data, error) -> Void in
            
            if error != nil {
                print(error)
            }
            // 1. Download the image into the struct's image field
            self.post.image = CustomImage(data: data!)
            //self.post.image = #imageLiteral(resourceName: "default.png")
            
            self.imageView.contentMode = UIViewContentMode.scaleAspectFill
            self.imageView.image = self.post.image
            print("doing")
            self.view.addSubview(self.imageView)
        })
    }
    
    func initTitleText() {
        titleLabel = UILabel(frame: CGRect(x: 10, y: imageView.frame.maxY + 15, width: view.frame.width, height: 22))
        titleLabel.font = UIFont.init(name: "Roboto-Regular", size: 22.0)
        titleLabel.text = post.title
        titleLabel.textAlignment = NSTextAlignment.left
        
        view.addSubview(titleLabel)
    }
    
    func initPoster() {
        poster = UILabel(frame: CGRect(x: 11, y: titleLabel.frame.maxY + 5, width: view.frame.width, height: 12))
        poster.textColor = UIColor.init(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        poster.textAlignment = NSTextAlignment.left
        poster.font = UIFont.init(name: "Roboto-Light", size: 12.0)
        poster.adjustsFontForContentSizeCategory = true
        
        poster.text = post.poster! + " " + post.dateString!
        
        //posterText.layer.borderColor = UIColor.lightGray.cgColor
        //posterText.layer.borderWidth = 1.0
        
        view.addSubview(poster)
    }
    
    func initDescription() {
        descriptionText = UITextView(frame: CGRect(x: 6, y: poster.frame.maxY, width: view.frame.width - 6, height: view.frame.height - 40 - poster.frame.maxY))
        descriptionText.textAlignment = NSTextAlignment.left
        descriptionText.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionText.text = post.description
        descriptionText.contentInset = UIEdgeInsets(top: -3, left: 0, bottom: 0, right: 0)
        
        view.addSubview(descriptionText)
    }
    
    func initNumInterested() {
        numInterestedButton = UIButton(frame: CGRect(x: 0, y: descriptionText.frame.maxY, width: view.frame.width / 2, height: 40))
        numInterestedButton.setTitle("\(Int(post.numLikes!)) people interested", for: .normal)
        numInterestedButton.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 230/255, alpha: 1.0)
        numInterestedButton.setTitleColor(UIColor.white, for: .normal)
        
        view.addSubview(numInterestedButton)
    }
    
    func initInterested() {
        interestedButton = UIButton(frame: CGRect(x: numInterestedButton.frame.maxX, y: numInterestedButton.frame.minY, width: view.frame.width / 2, height: 40))
        interestedButton.setTitle("I'm Interested!", for: .normal)
        interestedButton.backgroundColor = UIColor.init(red: 230/255, green: 200/255, blue: 200/255, alpha: 1.0)
        interestedButton.setTitleColor(UIColor.white, for: .normal)
        
        interestedButton.addTarget(self, action: #selector(interested), for: UIControlEvents.touchUpInside)
        
        view.addSubview(interestedButton)
    }
    
    func interested() {
        if mainInstance.isFaved[indexPath.row] {
            
            mainInstance.isFaved[indexPath.row] = false
            
            let dbRef = FIRDatabase.database().reference()
            
            let keyRef = self.postsRef
            
            let userId = (FIRAuth.auth()?.currentUser?.uid)!
            
            let userLiked = [userId: FIRAuth.auth()?.currentUser?.uid] as [String : Any]
            
            //let key = keyRef.key
            let specificRef = keyRef.child((mainInstance.postCollectionView.cellForItem(at: indexPath) as! PostCollectionViewCell).post.postID!) //The reference to the specific post
            
            //specificRef.child("numLikes").setValue((specificRef.child("numLikes") as! Int) + 1)
            
            let key = specificRef.key
            
            let usersLikedRef = specificRef.child("Users Liked")
            let usersLikedKey = usersLikedRef.child(userId)
            
            dbRef.child("Posts").child(usersLikedRef.key).observeSingleEvent(of: .value, with: { (snapshot) in
                print(usersLikedKey.key)
                print(usersLikedRef.key)
                if snapshot.hasChild(usersLikedKey.key) {
                    print("KLJFKLJDFA")
                } else {
                    let update = ["/\(key)/": userLiked]
                    
                    //usersLikedRef.updateChildValues(update)
                    usersLikedKey.setValue(userLiked[(FIRAuth.auth()?.currentUser?.uid)!])
                    mainInstance.posts[self.indexPath.row].numLikes! += 1
                    self.initNumInterested()
                    specificRef.child("numLikes").setValue(mainInstance.posts[self.indexPath.row].numLikes)
                }
            })
            
            
        } else {
            mainInstance.isFaved[indexPath.row] = true
            
            let keyRef = self.postsRef
            
            let userId = (FIRAuth.auth()?.currentUser?.uid)!
            
            let userLiked = [userId: FIRAuth.auth()?.currentUser?.uid] as [String : Any]
            
            //let key = keyRef.key
            let specificRef = keyRef.child((mainInstance.postCollectionView.cellForItem(at: indexPath) as! PostCollectionViewCell).post.postID!) //The reference to the specific post
            
            let key = specificRef.key
            
            let usersLikedRef = specificRef.child("Users Liked")
            let usersLikedKey = usersLikedRef.child(userId)
            
            usersLikedKey.removeValue()
            
            /*let update = ["/\(key)/": userLiked]
             
             //usersLikedRef.updateChildValues(update)
             usersLikedKey.setValue(userLiked[(FIRAuth.auth()?.currentUser?.uid)!])*/
            mainInstance.posts[indexPath.row].numLikes! -= 1
            self.initNumInterested()
            specificRef.child("numLikes").setValue(mainInstance.posts[indexPath.row].numLikes)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
