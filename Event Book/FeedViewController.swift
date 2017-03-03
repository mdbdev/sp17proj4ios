//
//  FeedViewController.swift
//  FirebaseDemo
//
//  Created by Sahil Lamba on 2/12/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import UIKit
import Firebase
import FaveButton

class FeedViewController: UIViewController {
    
    var newPostView: UITextField!
    var newPostButton: UIButton!
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var storage: FIRStorageReference = FIRStorage.storage().reference()
    var currentUser: User?
    var detailPost: Post?
    
    var expandedCellIdentifier = "ExpandableCell"
    var isExpanded = [Bool]()
    
    var pathToPass: IndexPath!
    
    var cellWidth: CGFloat {
        return mainInstance.postCollectionView.frame.size.width
    }
    
    var items: [UIImageView] = []
    
    //For sample post
    //let samplePost = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        //posts.append(samplePost)
        fetchUser {
            self.fetchPosts() {
                
                self.initPostButton()
                self.setupCollectionView()
                
                activityIndicator.stopAnimating()
            }
        }
        
        
        // Do any additional setup after loading the view.
        
    }
    
    func initPostButton() {
        newPostButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 40, width: view.frame.width, height: 40))
        newPostButton.setTitle("New Event", for: .normal)
        newPostButton.setTitleColor(UIColor.white, for: .normal)
        newPostButton.backgroundColor = UIColor.gray
        
        newPostButton.layer.zPosition = 1000
        
        newPostButton.addTarget(self, action: #selector(addPost), for: UIControlEvents.touchUpInside)
        
        view.addSubview(newPostButton)
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
    
    func imageWithGradient(img:UIImage!) -> UIImage {
        
        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()
        
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        
        let bottom = UIColor(red: 22/255, green: 30/255, blue: 43/255, alpha: 1.0).cgColor
        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
        
        var colors = [top, bottom] as CFArray
        var gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        var startPoint = CGPoint(x: img.size.width/2, y: img.size.height / 2 - 25)
        var endPoint = CGPoint(x: img.size.width/2, y: img.size.height / 2 + mainInstance.imageHeight / 2)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        colors = [top, bottom] as CFArray
        
        gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        startPoint = CGPoint(x: img.size.width/2, y: img.size.height / 2 + 51)
        endPoint = CGPoint(x: img.size.width/2, y: img.size.height / 2 + mainInstance.imageHeight / 2)
        
       // context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    func setupCollectionView() {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let cvLayout = UICollectionViewFlowLayout()
        mainInstance.postCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 40), collectionViewLayout: cvLayout)
        mainInstance.postCollectionView.delegate = self
        mainInstance.postCollectionView.dataSource = self
        mainInstance.postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "post")
        
        mainInstance.postCollectionView.backgroundColor = UIColor.lightGray
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        mainInstance.postCollectionView!.collectionViewLayout = layout
        
        isExpanded = Array(repeating: false, count: mainInstance.posts.count)
        mainInstance.isFaved = Array(repeating: false, count: mainInstance.posts.count)
        
        view.addSubview(mainInstance.postCollectionView)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPost" {
            let listVC = segue.destination as! NewPostViewController
            //pokemonsToPass = pokemonsToPass.sorted{$0.name < $1.name} //sort alphabetically
            //listVC.pokemons = self.pokemonsToPass
        }
        if segue.identifier == "toDetail" {
            let VC = segue.destination as! DetailViewController
            VC.indexPath = pathToPass
            VC.post = detailPost
        }
    }
    
    func addPost(sender: UIButton!) {
        /*//TODO: Implement using Firebase!
         let postText = newPostView.text!
         self.newPostView.text = ""
         let newPost = ["text": postText, "poster": currentUser?.firstname, "imageUrl": currentUser?.email, "numLikes": 0, "posterId": currentUser?.id] as [String : Any]
         let key = postsRef.childByAutoId().key
         let childUpdates = ["/\(key)/": newPost]
         postsRef.updateChildValues(childUpdates)*/
        performSegue(withIdentifier: "toPost", sender: nil)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            mainInstance.posts.append(post)
            
            withBlock()
        })
    }
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((self.auth?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value)
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            self.currentUser = user
            withBlock()
            
        })
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

let imageCache = NSCache<AnyObject, AnyObject>()

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
        for i in 0 ... mainInstance.posts.count {
            items.append(UIImageView.init())
        }
        return mainInstance.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mainInstance.postCollectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostCollectionViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        /////
        cell.indexPath = indexPath
        cell.delegate = self
        /////configure Cell
        
        cell.awakeFromNib()
        let postInQuestion = mainInstance.posts[indexPath.row]
        cell.postText.text = postInQuestion.description
        cell.posterText.text = postInQuestion.title
        cell.authorText.text = postInQuestion.dateString! + " " + postInQuestion.poster!
        
        cell.profileImage.image = nil
        
        postInQuestion.getProfilePic {
            cell.profileImage.image = self.imageWithGradient(img: postInQuestion.image)
        }
        
        cell.layer.zPosition = CGFloat(indexPath.row)
        
        cell.expandButton.tag = indexPath.row
        cell.expandButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        cell.post = postInQuestion
        
        return cell
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: mainInstance.postCollectionView.bounds.width - 20, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isExpanded[indexPath.row] == true {
            return CGSize(width: self.cellWidth, height: mainInstance.imageHeight + (mainInstance.postCollectionView.cellForItem(at: indexPath) as! PostCollectionViewCell).postText.frame.height)
            
        } else{
            return CGSize(width: cellWidth, height: mainInstance.imageHeight)
        }
        
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        detailPost = mainInstance.posts[indexPath.row]
        pathToPass = indexPath
        self.performSegue(withIdentifier: "toDetail", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension FeedViewController:ExpandedCellDelegate{
    func likePressed(indexPath: IndexPath) {
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        UIView.animate(withDuration: 0.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            DispatchQueue.main.async {
                mainInstance.postCollectionView.reloadItems(at: [indexPath])
            }
        }, completion: { success in
            
        })
    }
}
