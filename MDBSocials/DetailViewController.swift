//
//  DetailViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/25/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

enum GoingStatus {
    case interested
    case notResponded
}

class DetailViewController: UIViewController {

    var post: Post!
    var currentUser: User!
    var image: UIImageView!
    var name: UILabel!
    var author: UILabel!
    var date: UILabel!
    var eventDescription: UITextView!
    var descriptionTitle: UILabel!
    var numInterestedButton: UIButton!
    var interestedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = post.name
        setUpPic()
        setUpName()
        setUpAuthor()
        setUpDate()
        fetchUser {
            self.setUpNumInterestedButton()
            self.setUpInterestedButton()
            self.setUpDescriptionTitle()
            self.setUpEventDescription()

        }
    }
    
    func setUpPic() {
        let dimmension = view.frame.width * 0.6
        image = UIImageView(frame: CGRect(x: view.frame.width / 2 - dimmension / 2, y: (navigationController?.navigationBar.frame.maxY)! + 30, width: dimmension, height: dimmension))
        image.image = post.image
        image.layer.cornerRadius = 5
        image.backgroundColor = UIColor.black
        image.layer.masksToBounds = true
        view.addSubview(image)
    }
    
    func setUpName() {
        name = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        name.text = post.name
        name.font = UIFont.systemFont(ofSize: 23, weight: 1)
        name.sizeToFit()
        name.frame.origin.y = image.frame.maxY + 10
        name.frame.origin.x = view.frame.width / 2 - name.frame.width / 2
        name.textColor = Constants.purpleColor
        view.addSubview(name)
    }
    
    func setUpAuthor() {
        author = UILabel(frame: CGRect(x: 0, y: name.frame.maxY + 5, width: 50, height: 50))
        author.text = "Posted by " + post.name!
        author.font = UIFont.systemFont(ofSize: 13)
        author.sizeToFit()
        author.frame.origin.x = view.frame.width / 2 - author.frame.width / 2
        view.addSubview(author)
    }
    
    func setUpDate() {
        date = UILabel(frame: CGRect(x: 0, y: author.frame.maxY + 5, width: 50, height: 50))
        date.text = "Happening on " + post.date!
        date.font = UIFont.boldSystemFont(ofSize: 13)
        date.sizeToFit()
        date.frame.origin.x = view.frame.width / 2 - date.frame.width / 2
        view.addSubview(date)
    }
    
    func setUpNumInterestedButton() {
        numInterestedButton = UIButton(frame: CGRect(x: view.frame.width / 2 - view.frame.width * 0.35, y: date.frame.maxY + 20, width: view.frame.width / 3, height: 35))
        numInterestedButton.setTitle("\(post.interestedUsers.count)" + " people interested", for: .normal)
        numInterestedButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        numInterestedButton.backgroundColor = Constants.purpleColor
        numInterestedButton.layer.cornerRadius = 3
        numInterestedButton.layer.masksToBounds = true
        numInterestedButton.addTarget(self, action: #selector(viewInterested), for: .touchUpInside)
        view.addSubview(numInterestedButton)
        
    }
    
    func setUpInterestedButton() {
        interestedButton = UIButton(frame: CGRect(x: numInterestedButton.frame.maxX + 15, y: date.frame.maxY + 20, width: view.frame.width / 3, height: 35))
        interestedButton.setTitle("Interested", for: .normal)
        interestedButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        interestedButton.backgroundColor = Constants.purpleColor
        interestedButton.layer.cornerRadius = 3
        interestedButton.layer.masksToBounds = true
        interestedButton.addTarget(self, action: #selector(interestedClicked), for: .touchUpInside)
        interestedButton.isSelected = false
        view.addSubview(interestedButton)
    }
    
    func viewInterested() {
        performSegue(withIdentifier: "toList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toList" {
            let listVC = segue.destination as! ListViewController
            listVC.names = post.interestedUsers
        }
    }
    
    func interestedClicked() {
        if !interestedButton.isSelected {
            interestedButton.setTitle("Not Interested", for: .normal)
            post.addInterestedUser(withId: currentUser.id!)
        } else {
            interestedButton.setTitle("Interested", for: .normal)
            post.removeInterestedUser(withId: currentUser.id!)
        }
        numInterestedButton.setTitle("\(post.interestedUsers.count)" + " people interested", for: .normal) //change number
        interestedButton.isSelected = !interestedButton.isSelected
    }
    
    func setUpDescriptionTitle() {
        descriptionTitle = UILabel(frame: CGRect(x: 0, y: numInterestedButton.frame.maxY + 15, width: 50, height: 50))
        descriptionTitle.text = "Description"
        descriptionTitle.font = UIFont.boldSystemFont(ofSize: 15)
        descriptionTitle.sizeToFit()
        descriptionTitle.frame.origin.x = view.frame.width / 2 - descriptionTitle.frame.width / 2
        view.addSubview(descriptionTitle)
    }
    
    func setUpEventDescription() {
        eventDescription = UITextView(frame: CGRect(x: view.frame.width * 0.1, y: descriptionTitle.frame.maxY, width: view.frame.width * 0.8, height: view.frame.height))
        eventDescription.text = post.description!
        eventDescription.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(eventDescription)
    }
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            self.currentUser = user
            withBlock()
            
        })
    }

}
