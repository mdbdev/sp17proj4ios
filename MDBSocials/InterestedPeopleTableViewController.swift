//
//  InterestedPeopleTableViewController.swift
//  MDBSocials
//
//  Created by Amy on 2/25/17.
//  Copyright © 2017 Amy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class InterestedPeopleViewController: UIViewController {
    
    static var interestedUsers: [String] = []
    var currentUser: User!
    var currentUser2: User!
    static var interestedNames: [String] = []
    static var interestedPics: [String] = []
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Users")
 
    
    var tableView: UITableView!
        override func viewDidLoad() {
        super.viewDidLoad()
   
        setUpTableView()
        
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.minY, width: view.frame.width, height: view.frame.height))
        tableView.register(InterestedPeopleTableViewCell.self, forCellReuseIdentifier: "userCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        view.addSubview(tableView)

    }
}


extension InterestedPeopleViewController: UITableViewDataSource, UITableViewDelegate{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return InterestedPeopleViewController.interestedUsers.count
            
        }
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell1 = cell as! InterestedPeopleTableViewCell
        cell1.userName.text = InterestedPeopleViewController.interestedNames[indexPath.row]
        cell1.userName.sizeToFit()
        cell1.userName.frame.origin.y = tableView.rowHeight / 2 - 5
        cell1.userName.frame.origin.x = cell1.userImage.frame.maxX + 10
        let user = User()
        user.imageUrl = InterestedPeopleViewController.interestedPics[indexPath.row]
        user.id = InterestedPeopleViewController.interestedUsers[indexPath.row]
        user.getProfilePic {
            cell1.userImage.image = user.image
        }
       
            
    }
    
        // Setting up cells
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! InterestedPeopleTableViewCell
            for subview in userCell.contentView.subviews {
                subview.removeFromSuperview() //remove stuff from cell before initializing
            }
            userCell.awakeFromNib() //initialize cell
            
            return userCell
        }
}
        
        
    
     
        
        
        




