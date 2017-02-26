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
        tableView.rowHeight = 50
        view.addSubview(tableView)

    }
}


extension InterestedPeopleViewController: UITableViewDataSource, UITableViewDelegate{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("what is the number o users")
            print(InterestedPeopleViewController.interestedUsers.count)
            return InterestedPeopleViewController.interestedUsers.count
            
        }
        
        // Setting up cells
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! InterestedPeopleTableViewCell
            for subview in userCell.contentView.subviews {
                subview.removeFromSuperview() //remove stuff from cell before initializing
            }
            userCell.awakeFromNib() //initialize cell
           /* let currentUser = InterestedPeopleViewController.interestedUsers[indexPath.row]
            currentUser2 = postsRef.
            currentUser.getProfilePic {
                userCell.userImage.image = currentUser.image
 */
            
            //setting up text
            userCell.userName.text = currentUser.name
            userCell.userName.sizeToFit()
            userCell.userName.frame.origin.y = tableView.rowHeight / 2 - 5
            userCell.userName.frame.origin.x = userCell.userImage.frame.maxX + 10
          
            return userCell
        }
}
        
        
    
     
        
        
        




