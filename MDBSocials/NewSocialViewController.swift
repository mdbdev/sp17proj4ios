//
//  NewSocialViewController.swift
//  MDBSocials
//
//  Created by Zach Govani on 2/25/17.
//  Copyright © 2017 Zach Govani. All rights reserved.
//

import UIKit
import Firebase

class NewSocialViewController: UIViewController {
    
    var newPostView: UITextField!
    var newPostButton: UIButton!
    var currentUser: User!
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewPostView()
        setupButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNewPostView() {
        newPostView = UITextField(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 0.3 * UIScreen.main.bounds.height))
        print("i reach here")
        newPostView.layoutIfNeeded()
        newPostView.layer.shadowRadius = 2.0
        newPostView.layer.masksToBounds = true
        newPostView.placeholder = "Write a new post..."
        view.addSubview(newPostView)
    }
    
    func setupButton() {
        newPostButton = UIButton(frame: CGRect(x: 10, y: newPostView.frame.maxY + 10, width: UIScreen.main.bounds.width - 20, height: 50))
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
    
    func addNewPost(sender: UIButton!) {
        //TODO: Implement using Firebase!
        let postText = newPostView.text!
        self.newPostView.text = ""
        let newPost = ["description": postText, "poster": currentUser?.name, "imageUrl": currentUser?.imageUrl, "numLikes": 0, "posterId": currentUser?.id, "likers": []] as [String : Any]
        let key = postsRef.childByAutoId().key
        let childUpdates = ["/\(key)/": newPost]
        postsRef.updateChildValues(childUpdates)
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
