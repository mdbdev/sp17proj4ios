//
//  LikersViewController.swift
//  MDBSocials
//
//  Created by Zach Govani on 3/2/17.
//  Copyright © 2017 Zach Govani. All rights reserved.
//

import UIKit
import Firebase

class LikersViewController: UIViewController {
    
    var post: Post!
    var tableView: UITableView!
    var currentUser: User!
    var currentUserId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView(){
        //Initialize TableView Object here
        tableView = UITableView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.maxY, width: view.frame.width, height: view.frame.height))
        //Register the tableViewCell you are using
        tableView.register(LikerTableViewCell.self, forCellReuseIdentifier: "liker")
        
        //Set properties of TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 50/2, right: 0)
        
        //Add tableView to view
        view.addSubview(tableView)
    }
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child(currentUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            print(self.currentUserId)
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            self.currentUser = user
            print("The user's email is \(self.currentUser?.email)")
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

extension LikersViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.likers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liker") as! LikerTableViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        currentUserId = post.likers[indexPath.row]
        print(indexPath.row)
        fetchUser {
            cell.name.text = self.currentUser.name
        }
        cell.name.adjustsFontSizeToFitWidth = true
        return cell
    }
    
}
