//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/21/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    var tableView: UITableView!
    var posts: [Post] = []
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var storage: FIRStorageReference = FIRStorage.storage().reference()
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts {
            self.setUpNavBar()
            self.setUpTableView()
            self.automaticallyAdjustsScrollViewInsets = false //makes navbar not cover tableview
        }
    }
    
    func setUpNavBar() {
        self.title = "Feed"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(red: 92/255, green: 121/255, blue: 254/255, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Post", style: .plain, target: self, action: #selector(newPost))
    }
    
    func newPost() {
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.modalPresentationStyle = .popover
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "NewSocialVC") as! NewSocialViewController
        newVC.delegate = self
        self.present(newVC, animated: true, completion: nil)
//        performSegue(withIdentifier: "toNewPost", sender: self)
    }
    
    func logOut() {
        let firebaseAuth = auth
        do {
            try firebaseAuth?.signOut()
            let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
            self.show(feedVC, sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height))
        //Register the tableViewCell you are using
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
        //Set properties of TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150 / 2, right: 0)
        tableView.tableFooterView = UIView() // gets rid of the extra cells beneath
        view.addSubview(tableView)
    }

    func addNewPostToDatabase(post: [String: Any]) {
        let key = postsRef.childByAutoId().key
        let childUpdates = ["/\(key)/": post]
        postsRef.updateChildValues(childUpdates)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            self.posts.append(post)
            withBlock() //ensures that next block is called
        })
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedTableViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview() //remove stuff from cell before initializing
        }
        cell.awakeFromNib() //initialize cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension FeedViewController: NewSocialViewControllerDelegate {
    func sendValue(_ info: [String: Any]) { //gets the information from new post
        addNewPostToDatabase(post: info)
    }
}
