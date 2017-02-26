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
    

}
