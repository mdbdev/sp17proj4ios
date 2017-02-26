//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/21/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet

class FeedViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var tableView: UITableView!
    var posts: [Post] = []
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var storage: FIRStorageReference = FIRStorage.storage().reference()
    var postToPass: Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        fetchPosts {
            self.setUpUI()
        }
    }

    
    func setUpUI() {
        setUpTableView()
        automaticallyAdjustsScrollViewInsets = false //makes navbar not cover tableview
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
    }
    
    func logOut() {
        let firebaseAuth = auth
        do {
            try firebaseAuth?.signOut()
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
            self.show(loginVC, sender: nil)
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
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.rowHeight = 120
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150 / 2, right: 0)
        tableView.tableFooterView = UIView() // gets rid of the extra cells beneath
        view.addSubview(tableView)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage()
    }

    func addNewPostToDatabase(post: [String: Any]) {
        let key = postsRef.childByAutoId().key
        let childUpdates = ["/\(key)/": post]
        postsRef.updateChildValues(childUpdates)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        postsRef.observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            self.posts.append(post)
            withBlock() //ensures that next block is called
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.post = postToPass
        }
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
        let currentPost = posts[indexPath.row]
        DispatchQueue.main.async {
            currentPost.getProfilePic(withBlock: {(image) in
                cell.eventPicture.image = image
            })
        }
        cell.eventName.text = currentPost.name
        cell.eventName.sizeToFit()
        cell.eventName.frame.origin.x = cell.eventPicture.frame.maxX + ((view.frame.width - cell.eventPicture.frame.maxX) / 2.25) - cell.eventName.frame.width / 2
        cell.author.text = "Posted by " + currentPost.author!
        cell.author.sizeToFit()
        cell.author.frame.origin.x = cell.eventName.frame.minX - cell.author.frame.width / 2 + cell.eventName.frame.width / 2
        cell.date.text = "Happening on " + currentPost.date!
        cell.date.sizeToFit()
        cell.date.frame.origin.x = cell.eventName.frame.minX - cell.date.frame.width / 2 + cell.eventName.frame.width / 2
        cell.interests.text = "\(currentPost.interestedUsers.count)" + " Interested"
        cell.interests.sizeToFit()
        cell.interests.frame.origin.x = cell.eventName.frame.minX - cell.interests.frame.width / 2 + cell.eventName.frame.width / 2 + cell.interestsImage.frame.width / 2//move it to the right a bit to center with icon
        cell.interestsImage.frame.origin.x = cell.interests.frame.minX - cell.interestsImage.frame.width - 3
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postToPass = posts[indexPath.row]
        self.performSegue(withIdentifier: "toDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
}

extension FeedViewController: NewSocialViewControllerDelegate {
    func sendValue(_ info: [String: Any]) { //gets the information from new post
        addNewPostToDatabase(post: info)
    }
}
