//
//  Post.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/24/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Post {
    
    var author: String?
    var authorId: String?
    var name: String?
    var description: String?
    var imageUrl: String?
    var image: UIImage?
    var id: String?
    var interestedUsers: [String] = [] //contains IDs
    var date: String?
    let postRef = FIRDatabase.database().reference().child("Posts")
    
    init(id: String, postDict: [String:Any]?) {
        self.id = id
        if postDict != nil {
            if let description = postDict!["description"] as? String {
                self.description = description
            }
            if let author = postDict!["author"] as? String {
                self.author = author
            }
            if let authorId = postDict!["authorId"] as? String {
                self.authorId = authorId
            }
            if let name = postDict!["name"] as? String {
                self.name = name
            }
            if let date = postDict!["date"] as? String {
                self.date = date
            }
            if let imageUrl = postDict!["imageUrl"] as? String {
                self.imageUrl = imageUrl
            }
            if let interestedUsers = postDict!["interestedUsers"] as? [String] {
                self.interestedUsers = interestedUsers
            }
        }
    }
    
    func getProfilePic(withBlock: @escaping (UIImage) -> ()) {
        let ref = FIRStorage.storage().reference(forURL: imageUrl!) // use image URL to download image from storage
        ref.data(withMaxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                print(error)
            } else {
                self.image = UIImage(data: data!)
                withBlock(self.image!)
            }
        }
    }
    
    func getInterestedUsers(withBlock: @escaping (Int) -> Void) {
        postRef.child(self.id!).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let idArray = value?["interestedUsers"] as? [String] ?? []
//                for val in idArray {
//                    User.generateUserModel(withId: val, withBlock: { user in //how to pass list of users??
//                        
//                    })
//                }
            withBlock(idArray.count)
        })
    }
    
    func addInterestedUser(withId: String) {
        if !self.interestedUsers.contains(withId) {
            self.interestedUsers.append(withId)
            let childUpdates = ["\(self.id!)/interestedUsers": self.interestedUsers]
            postRef.updateChildValues(childUpdates) //update interested array
        }
    }
    
    func removeInterestedUser(withId: String) {
        self.interestedUsers.remove(at: self.interestedUsers.index(of: withId)!)
        let childUpdates = ["\(self.id!)/interestedUsers": self.interestedUsers]
        postRef.updateChildValues(childUpdates) //update interested array
    }
    

}
