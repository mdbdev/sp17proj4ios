//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/21/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

enum GoingStatus {
    case interested
    case notResponded
}

class FeedViewController: UIViewController {

    var emptyView: UIView!
    var tableView: UITableView!
    var posts: [Post] = []
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var storage: FIRStorageReference = FIRStorage.storage().reference()
    var postToPass: Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpEmptyTable()
        fetchPosts {
            self.setUpUI()
        }
    }
    
    func setUpEmptyTable() {
        //empty view
        emptyView = UIView()
        if posts.count == 0 {
            let emptyImage = UIImageView(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 2 - view.frame.width * 0.25, width: 100, height: 100))
            emptyImage.image = #imageLiteral(resourceName: "newpost")
            emptyView.addSubview(emptyImage)
            let emptyLabel = UILabel()
            emptyLabel.text = "No posts to show."
            emptyLabel.sizeToFit()
            emptyLabel.frame.origin.x = view.frame.width / 2 - emptyLabel.frame.width / 2
            emptyLabel.frame.origin.y = emptyImage.frame.maxY + 20
            emptyView.addSubview(emptyLabel)
            view.addSubview(emptyView)
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
        navigationController?.navigationBar.barTintColor = Constants.purpleColor
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
        emptyView.removeFromSuperview()
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
        MDBSocialsUtils.clearCell(cell: cell)
        cell.awakeFromNib() //initialize cell
        cell.delegate = self
        let currentPost = posts[posts.count - 1 - indexPath.row] //show most recent posts first
        cell.tag = posts.count - 1 - indexPath.row //associate row number with each cell
        currentPost.getProfilePic(withBlock: {(image) in
            cell.eventPicture.image = image
        })
        cell.eventName.text = currentPost.name
        cell.eventName.sizeToFit()
        cell.eventName.frame.origin.x = cell.eventPicture.frame.maxX + ((view.frame.width - cell.eventPicture.frame.maxX) / 2.25) - cell.eventName.frame.width / 2
        cell.author.text = "Posted by " + currentPost.author!
        cell.author.sizeToFit()
        cell.author.frame.origin.x = cell.eventName.frame.minX - cell.author.frame.width / 2 + cell.eventName.frame.width / 2
        cell.date.text = "Happening on " + currentPost.date!
        cell.date.sizeToFit()
        cell.date.frame.origin.x = cell.eventName.frame.minX - cell.date.frame.width / 2 + cell.eventName.frame.width / 2
        addPostObserver(forPost: currentPost, updateCell: cell)
        return cell
    }
    
    func addPostObserver(forPost: Post, updateCell: FeedTableViewCell) { //update num interested when button clicked
        self.postsRef.child("\(forPost.id!)").observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let idArray = value?["interestedUsers"] as? [String] ?? []
            DispatchQueue.main.async {
                updateCell.interests.text = "\(idArray.count)" + " Interested"
                updateCell.interests.sizeToFit()
                updateCell.interests.frame.origin.x = updateCell.eventName.frame.minX - updateCell.interests.frame.width / 2 + updateCell.eventName.frame.width / 2 + updateCell.interestsImage.frame.width / 2 - 35//move it to the right a bit to center with icon
                updateCell.interests.frame.origin.y = updateCell.date.frame.minY + 20
                let xPos = updateCell.interests.frame.minX - 23
                updateCell.interestsImage.frame = CGRect(x: xPos, y: updateCell.date.frame.minY + 17, width: 20, height: 20)
                updateCell.interestedButton.frame = CGRect(x: updateCell.interests.frame.maxX + 8, y: updateCell.date.frame.minY + 20, width: 70, height: updateCell.interests.frame.height )
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postToPass = posts[posts.count - 1 - indexPath.row]
        self.performSegue(withIdentifier: "toDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
}

extension FeedViewController: NewSocialViewControllerDelegate {
    func sendValue(_ info: [String: Any]) { //gets the information from new post
        addNewPostToDatabase(post: info)
    }
}

extension FeedViewController: FeedCellDelegate {
    func addInterestedUser(forCell: FeedTableViewCell) {
        posts[forCell.tag].addInterestedUser(withId: (FIRAuth.auth()?.currentUser?.uid)!)
    }
    
    func removeInterestedUser(forCell: FeedTableViewCell) {
        posts[forCell.tag].removeInterestedUser(withId: (FIRAuth.auth()?.currentUser?.uid)!)
    }
}
