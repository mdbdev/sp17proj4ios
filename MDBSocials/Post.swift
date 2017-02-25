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
            if let authorId = postDict!["authorId"] as? Int {
                self.authorId = "\(authorId)"
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
        }
    }
    

}
